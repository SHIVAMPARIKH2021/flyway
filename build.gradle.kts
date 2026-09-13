import java.io.File

buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath("org.postgresql:postgresql:42.7.3")
        classpath("org.flywaydb:flyway-database-postgresql:10.15.0")
    }
}

plugins {
    id("org.flywaydb.flyway") version "10.15.0"
}

// 1. Environment & Target Database Selection
val targetEnv = project.findProperty("env")?.toString() ?: System.getenv("APP_ENV") ?: "local"
val targetDb = project.findProperty("db")?.toString() ?: "emfs" // e.g. -Pdb=funds or -Pdb=emfs

val yamlConfigFile = file("envs/application-$targetEnv.yml")

fun parseSimpleYaml(file: File): Map<String, String> {
    if (!file.exists()) return emptyMap()
    val map = mutableMapOf<String, String>()
    var currentSection = ""

    file.readLines().forEach { line ->
        val trimmed = line.trim()
        if (trimmed.isEmpty() || trimmed.startsWith("#")) return@forEach

        if (!line.startsWith(" ") && !line.startsWith("\t") && trimmed.endsWith(":")) {
            currentSection = trimmed.removeSuffix(":")
        } else if (trimmed.contains(":")) {
            val parts = trimmed.split(":", limit = 2)
            val key = parts[0].trim()
            val value = parts[1].trim().trim('"', '\'')
            val fullKey = if (currentSection.isNotEmpty()) "$currentSection.$key" else key
            map[fullKey] = value
        }
    }
    return map
}

val yamlConfig = parseSimpleYaml(yamlConfigFile)

// 2. Resolve Credentials for the Chosen Database
// Looks up: funds.local.user or emfs.local.user
val dbUser = (project.findProperty("$targetDb.$targetEnv.user") as? String)
    ?: System.getenv("FLYWAY_USER")
    ?: "postgres"

val dbPassword = (project.findProperty("$targetDb.$targetEnv.password") as? String)
    ?: System.getenv("FLYWAY_PASSWORD")
    ?: "postgres"

val dbHost = yamlConfig["database.host"] ?: "localhost"
val dbPort = yamlConfig["database.port"] ?: "5432"
val dbName = yamlConfig["database.$targetDb.name"] ?: targetDb
val dbSslMode = yamlConfig["database.sslmode"] ?: "prefer"

val finalJdbcUrl = "jdbc:postgresql://$dbHost:$dbPort/$dbName?sslmode=$dbSslMode"

// 3. Configure Flyway
flyway {
    url = finalJdbcUrl
    user = dbUser
    password = dbPassword

    defaultSchema = "public"
    schemas = arrayOf("public")
    createSchemas = false

    // Dynamically point to src/main/resources/db/migration/funds or .../emfs
    locations = arrayOf("filesystem:src/main/resources/db/migration/$targetDb")
    encoding = "UTF-8"

    baselineOnMigrate = true
    baselineVersion = "0.0.0"
    baselineDescription = "Base $targetDb Baseline"

    cleanDisabled = (targetEnv != "local")
    outOfOrder = false
    validateOnMigrate = true
}

tasks.register("dbStatus") {
    doLast {
        println("----------------------------------------------")
        println("Target DB            : $targetDb")
        println("Target Environment   : $targetEnv")
        println("Database JDBC URL    : $finalJdbcUrl")
        println("Database User        : $dbUser")
        println("Migration Path       : src/main/resources/db/migration/$targetDb")
        println("----------------------------------------------")
    }
}