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
val targetDb = project.findProperty("db")?.toString() ?: "funds"

val yamlConfigFile = file("envs/application-$targetEnv.yaml")

fun parseSimpleYaml(file: File): Map<String, String> {
    if (!file.exists()) return emptyMap()
    val map = mutableMapOf<String, String>()
    val sectionStack = mutableListOf<Pair<Int, String>>()

    file.readLines().forEach { rawLine ->
        val trimmed = rawLine.trim()
        if (trimmed.isEmpty() || trimmed.startsWith("#")) return@forEach

        val indent = rawLine.indexOfFirst { !it.isWhitespace() }

        while (sectionStack.isNotEmpty() && sectionStack.last().first >= indent) {
            sectionStack.removeAt(sectionStack.size - 1)
        }

        if (trimmed.endsWith(":")) {
            val sectionName = trimmed.removeSuffix(":")
            sectionStack.add(indent to sectionName)
        } else if (trimmed.contains(":")) {
            val parts = trimmed.split(":", limit = 2)
            val key = parts[0].trim()
            val value = parts[1].trim().trim('"', '\'')
            val prefix = sectionStack.joinToString(".") { it.second }
            val fullKey = if (prefix.isNotEmpty()) "$prefix.$key" else key
            map[fullKey] = value
        }
    }
    return map
}

val yamlConfig = parseSimpleYaml(yamlConfigFile)

// 2. Resolve Credentials for the Chosen Database
val dbUser = (project.findProperty("$targetDb.$targetEnv.user") as? String)
    ?: (project.findProperty("funds.prod.user") as? String)
    ?: System.getenv("FLYWAY_USER")
    ?: "funds_admin"

val dbPassword = (project.findProperty("$targetDb.$targetEnv.password") as? String)
    ?: (project.findProperty("funds.prod.password") as? String)
    ?: System.getenv("FLYWAY_PASSWORD")
    ?: "strong/?12x3401"

val dbHost = yamlConfig["database.host"] ?: "192.168.1.9"
val dbPort = yamlConfig["database.port"] ?: "5432"
val dbName = yamlConfig["database.$targetDb.name"] ?: targetDb
val dbSslMode = yamlConfig["database.sslmode"] ?: "disable"

val targetSchema = if (targetDb == "funds") "sec_financials" else "public"

val finalJdbcUrl = "jdbc:postgresql://$dbHost:$dbPort/$dbName?sslmode=$dbSslMode"

// 3. Configure Flyway
flyway {
    url = finalJdbcUrl
    user = dbUser
    password = dbPassword

    defaultSchema = targetSchema
    schemas = arrayOf(targetSchema)
    createSchemas = true

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
        println("Target Schema        : $targetSchema")
        println("Migration Path       : src/main/resources/db/migration/$targetDb")
        println("----------------------------------------------")
    }
}