#!groovy

pipeline {
    agent {
        label "housekeeping"
    }
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
            stages {
                stage('1') {
                    steps {
                        script {
                            sh "./handleRelease.sh -r release-experiments -u HLXEasy"
                        }
                    }
                }
                stage('2') {
                    steps {
                        script {
                            sh "sleep 10"
                        }
                    }
                }
                stage('3') {
                    steps {
                        script {
                            sh "./handleRelease.sh -r release-experiments -u HLXEasy -o delete -t foo"
                        }
                    }
                }
                stage('4') {
                    steps {
                        script {
                            sh "sleep 10"
                        }
                    }
                }
                stage('5') {
                    steps {
                        script {
                            sh "./handleRelease.sh -r release-experiments -u HLXEasy -o release -t foo -n 'The release' -d 'The description'"
                        }
                    }
                }
                stage('6') {
                    steps {
                        script {
                            sh "sleep 10"
                        }
                    }
                }
                stage('7') {
                    steps {
                        script {
                            sh "echo \"Building A (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-A"
                            sh "./handleRelease.sh -r release-experiments -u HLXEasy -o upload -t foo -a Artifact-A -f TheArtifactA"
                        }
                    }
                }
            }
            //noinspection GroovyAssignabilityCheck
//            parallel {
//                stage('Prod A') {
//                    agent {
//                        label "housekeeping"
//                    }
//                    stages {
//                        stage('Remove Release if existing') {
//                            when {
//                                expression {
//                                    return isReleaseExisting(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments'
//                                    ) ==~ true
//                                }
//                            }
//                            steps {
//                                script {
//                                    sh "echo Release latest found"
//                                    removeRelease(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments'
//                                    )
//                                }
//                            }
//                        }
//                        stage('Create Release'){
//                            when {
//                                expression {
//                                    return isReleaseExisting(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments'
//                                    ) ==~ false
//                                }
//                            }
//                            steps {
//                                script {
//                                    sh "echo Release latest not found"
//                                    createRelease(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments'
//                                    )
//                                }
//                            }
//                        }
//                        stage('Build') {
//                            steps {
//                                script {
//                                    sh "echo \"Building A (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-A"
//                                    uploadArtifactToGitHub(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments',
//                                            artifactNameRemote: 'Artifact-A',
//                                    )
//                                }
//                            }
//                        }
//                    }
//                }
//                stage('Prod B') {
//                    agent {
//                        label "housekeeping"
//                    }
//                    stages {
//                        stage('Remove Release if existing') {
//                            when {
//                                expression {
//                                    return isReleaseExisting(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments',
//                                            tag: 'foo'
//                                    ) ==~ true
//                                }
//                            }
//                            steps {
//                                script {
//                                    sh "echo Release foo found"
//                                    removeRelease(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments',
//                                            tag: 'foo'
//                                    )
//                                }
//                            }
//                        }
//                        stage('Create Release'){
//                            when {
//                                expression {
//                                    return isReleaseExisting(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments',
//                                            tag: 'foo'
//                                    ) ==~ false
//                                }
//                            }
//                            steps {
//                                script {
//                                    sh "echo Release foo not found"
//                                    createRelease(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments',
//                                            tag: 'foo',
//                                            name: "This is the Release name",
//                                            description: "Release description",
//                                            preRelease: true
//                                    )
//                                }
//                            }
//                        }
//                        stage('Build') {
//                            steps {
//                                script {
//                                    sh "echo \"Building B (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-B"
//                                    uploadArtifactToGitHub(
//                                            user: 'HLXEasy',
//                                            repository: 'release-experiments',
//                                            tag: 'foo',
//                                            artifactNameRemote: 'Artifact-B',
//                                    )
//                                }
//                            }
//                        }
//                    }
//                }
//            }
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
