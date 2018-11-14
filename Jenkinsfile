#!groovy

pipeline {
    agent any
    options {
        timestamps()
        timeout(time: 2, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '5'))
        disableConcurrentBuilds()
    }
    environment {
        // In case another branch beside master or develop should be deployed, enter it here
        BRANCH_TO_DEPLOY = 'xyz'
        // This version will be used for the image tags if the branch is merged to master
        BUILDER_IMAGE_VERSION = '1.2'
        GITHUB_TOKEN = credentials('cdc81429-53c7-4521-81e9-83a7992bca76')
    }
    stages {
        stage('Feature-Branch') {
            when {
                not {
                    anyOf { branch 'develop'; branch 'master'; branch "${BRANCH_TO_DEPLOY}" }
                }
            }
            //noinspection GroovyAssignabilityCheck
            parallel {
                stage('Prod A') {
                    agent {
                        label "housekeeping"
                    }
                    steps {
                        script {
                            sh "echo \"Building A (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-A"
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "housekeeping"
                    }
                    steps {
                        script {
                            sh "echo \"Building B (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-B"
                        }
                    }
                }
            }
        }
        stage('Develop-Branch') {
            when {
                anyOf { branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
            //noinspection GroovyAssignabilityCheck
            parallel {
                stage('Prod A') {
                    agent {
                        label "housekeeping"
                    }
                    stages {
                        stage('Tag exists') {
                            when {
                                expression {
                                    return isTagExisting(
                                            user: 'HLXEasy',
                                            repository: 'release-experiments'
                                    ) ==~ true
                                }
                            }
                            steps {
                                script {
                                    sh "echo Tag latest found"
                                }
                            }
                        }
                        stage('Create tag'){
                            when {
                                expression {
                                    return isTagExisting(
                                            user: 'HLXEasy',
                                            repository: 'release-experiments'
                                    ) ==~ false
                                }
                            }
                            steps {
                                script {
                                    sh "echo Tag latest not found"
                                }
                            }
                        }
                        stage('Build') {
                            steps {
                                script {
                                    sh "echo \"Building A (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-A"
                                    uploadArtifactToGitHub(
                                            user: 'HLXEasy',
                                            repository: 'release-experiments',
                                            artifactNameRemote: 'Artifact-A',
                                    )
                                }
                            }
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "housekeeping"
                    }
                    stages {
                        stage('Tag exists') {
                            when {
                                expression {
                                    return isTagExisting(
                                            user: 'HLXEasy',
                                            repository: 'release-experiments',
                                            tag: 'foo'
                                    ) ==~ true
                                }
                            }
                            steps {
                                script {
                                    sh "echo Tag foo found"
                                }
                            }
                        }
                        stage('Create tag'){
                            when {
                                expression {
                                    return isTagExisting(
                                            user: 'HLXEasy',
                                            repository: 'release-experiments',
                                            tag: 'foo'
                                    ) ==~ false
                                }
                            }
                            steps {
                                script {
                                    sh "echo Tag foo not found"
                                }
                            }
                        }
                        stage('Build') {
                            steps {
                                script {
                                    sh "echo \"Building B (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-B"
                                    uploadArtifactToGitHub(
                                            user: 'HLXEasy',
                                            repository: 'release-experiments',
                                            artifactNameRemote: 'Artifact-B',
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        stage('Master-Branch') {
            when {
                branch 'master'
            }
            //noinspection GroovyAssignabilityCheck
            parallel {
                stage('Prod A') {
                    agent {
                        label "housekeeping"
                    }
                    steps {
                        script {
                            sh "echo \"Building A (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-A"
                            uploadArtifactToGitHub(
                                    user: 'HLXEasy',
                                    repository: 'release-experiments',
                                    tag: 'latest',
                                    artifactNameLocal: 'Artifact-A',
                                    artifactNameRemote: 'Artifact-A',
                            )
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "housekeeping"
                    }
                    steps {
                        script {
                            sh "echo \"Building B (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-B"
                            uploadArtifactToGitHub(
                                    user: 'HLXEasy',
                                    repository: 'release-experiments',
                                    tag: 'latest',
                                    artifactNameLocal: 'Artifact-B',
                                    artifactNameRemote: 'Artifact-B',
                            )
                        }
                    }
                }
            }
        }
    }
}
