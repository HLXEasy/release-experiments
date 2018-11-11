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
    }
    stages {
        stage('Feature-Branch') {
            when {
                not {
                    anyOf { branch 'develop'; branch 'master'; branch "${BRANCH_TO_DEPLOY}" }
                }
            }
            parallel {
                stage('Prod A') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            echo "Building A"
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            echo "Building B"
                        }
                    }
                }
            }
        }
        stage('Develop-Branch') {
            when {
                anyOf { branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
            parallel {
                stage('Prod A') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            echo "Building A"
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            echo "Building B"
                        }
                    }
                }
            }
        }
        stage('Master-Branch') {
            when {
                branch 'master'
            }
            parallel {
                stage('Prod A') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            echo "Building A"
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "docker"
                    }
                    steps {
                        script {
                            echo "Building B"
                        }
                    }
                }
            }
        }
    }
}
