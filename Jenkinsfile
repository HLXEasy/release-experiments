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
            parallel {
                stage('Prod A') {
                    agent {
                        label "housekeeping"
                    }
                    steps {
                        script {
                            echo "Building A (TimeStamp: ${currentBuild.startTimeInMillis})" | tee Artifact-A
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "housekeeping"
                    }
                    steps {
                        script {
                            echo "Building B (TimeStamp: ${currentBuild.startTimeInMillis})" | tee Artifact-B
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
                        label "housekeeping"
                    }
                    steps {
                        script {
                            echo "Building A (TimeStamp: ${currentBuild.startTimeInMillis})" | tee Artifact-A
                            uploadArtifactToGitHub("Artifact-A", "latest")
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "housekeeping"
                    }
                    steps {
                        script {
                            echo "Building B (TimeStamp: ${currentBuild.startTimeInMillis})" | tee Artifact-B
                            uploadArtifactToGitHub("Artifact-B", "latest")
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
                        label "housekeeping"
                    }
                    steps {
                        script {
                            echo "Building A (TimeStamp: ${currentBuild.startTimeInMillis})" | tee Artifact-A
                            uploadArtifactToGitHub("Artifact-A", "latest")
                        }
                    }
                }
                stage('Prod B') {
                    agent {
                        label "housekeeping"
                    }
                    steps {
                        script {
                            echo "Building B (TimeStamp: ${currentBuild.startTimeInMillis})" | tee Artifact-B
                            uploadArtifactToGitHub("Artifact-B", "latest")
                        }
                    }
                }
            }
        }
    }
}

def uploadArtifactToGitHub(String artifact, String version) {
    sh "docker run \\\n" +
            "--rm \\\n" +
            "-e GITHUB_TOKEN=${GITHUB_TOKEN} \\\n" +
            "-v ${WORKSPACE}:/filesToUpload \\\n" +
            "spectreproject/github-uploader:latest \\\n" +
            "github-release upload \\\n" +
            "    --user HLXEasy \\\n" +
            "    --repo release-experiments \\\n" +
            "    --tag ${version} \\\n" +
            "    --name \"${artifact}\" \\\n" +
            "    --file /filesToUpload/${artifact} \\\n" +
            "    --replace"
    sh "rm -f ${artifact}"
}
