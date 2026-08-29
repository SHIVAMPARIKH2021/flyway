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

// 1. Resolve Target Environment (Default: local)
val targetEnv = project.findProperty("env")?.toString() ?: System.getenv("APP_ENV") ?: "local"
val yamlConfigFile = file("envs/application-$targetEnv.yml")

// 2. Simple reader for non-sensitive YAML infrastructure config
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

// 3. Native Gradle Property Resolution:
// - Direct project property: -Pemfs.local.user=... or from ~/.gradle/gradle.properties
// - Environment variable: FLYWAY_USER
// - Fallback: YAML / defaults
val dbUser = (project.findProperty("emfs.$targetEnv.user") as? String)
    ?: (project.findProperty("emfsDbUser") as? String)
    ?: System.getenv("FLYWAY_USER")
    ?: "postgres"

val dbPassword = (project.findProperty("emfs.$targetEnv.password") as? String)
    ?: (project.findProperty("emfsDbPassword") as? String)
    ?: System.getenv("FLYWAY_PASSWORD")
    ?: "postgres"

val dbHost = yamlConfig["database.host"] ?: "localhost"
val dbPort = yamlConfig["database.port"] ?: "5432"
val dbName = yamlConfig["database.name"] ?: "emfs"
val dbSslMode = yamlConfig["database.sslmode"] ?: "prefer"

val finalJdbcUrl = System.getenv("FLYWAY_URL")
    ?: (project.findProperty("emfs.$targetEnv.url") as? String)
    ?: "jdbc:postgresql://$dbHost:$dbPort/$dbName?sslmode=$dbSslMode"

// 4. Flyway Configuration
flyway {
    url = finalJdbcUrl
    user = dbUser
    password = dbPassword

    defaultSchema = "public"
    schemas = arrayOf("public")
    createSchemas = false

    locations = arrayOf("filesystem:src/main/resources/db/migration")
    encoding = "UTF-8"

    baselineOnMigrate = true
    baselineVersion = "0.0.0"
    baselineDescription = "Base EMFS Public Baseline"

    cleanDisabled = (targetEnv != "local")
    outOfOrder = false
    validateOnMigrate = true
}

tasks.register("dbStatus") {
    doLast {
        println("----------------------------------------------")
        println("Project Name         : ${project.name}")
        println("Target Environment   : $targetEnv (envs/application-$targetEnv.yml)")
        println("Database JDBC URL    : $finalJdbcUrl")
        println("Database User        : $dbUser")
        println("Clean Task Disabled  : ${flyway.cleanDisabled}")
        println("----------------------------------------------")
    }
}