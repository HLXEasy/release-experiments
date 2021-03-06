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
//        GITHUB_TOKEN = credentials('cdc81429-53c7-4521-81e9-83a7992bca76')
        GITHUB_TOKEN = credentials('9b5219aa-4d80-4974-82dd-80dab77256e1')
        GIT_TAG_TO_CREATE = "Build${BUILD_NUMBER}"
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
        stage('Git tag handling') {
            when {
                anyOf { branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
            stages {
                stage('Create tag') {
                    steps {
                        createTag(
                                tag: "${GIT_TAG_TO_CREATE}",
                                commit: "HEAD",
                                comment: "Created tag ${GIT_TAG_TO_CREATE}"
                        )
                    }
                }
            }
        }
        stage('Develop-Branch') {
            when {
                anyOf { branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
//            stages {
//                stage('1') {
//                    steps {
//                        script {
//                            sh "./handleRelease.sh -r release-experiments -u spectrecoin -t foo"
//                        }
//                    }
//                }
//                stage('2') {
//                    steps {
//                        script {
//                            sh "sleep 10"
//                        }
//                    }
//                }
//                stage('3') {
//                    steps {
//                        script {
//                            sh "./handleRelease.sh -r release-experiments -u spectrecoin -o delete -t foo"
//                        }
//                    }
//                }
//                stage('4') {
//                    steps {
//                        script {
//                            sh "sleep 10"
//                        }
//                    }
//                }
//                stage('5') {
//                    steps {
//                        script {
//                            sh "./handleRelease.sh -r release-experiments -u spectrecoin -o release -t foo -n 'The release' -d 'The description'"
//                        }
//                    }
//                }
//                stage('6') {
//                    steps {
//                        script {
//                            sh "sleep 10"
//                        }
//                    }
//                }
//                stage('7') {
//                    steps {
//                        script {
//                            sh "echo \"Building A (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-A"
//                            sh "./handleRelease.sh -r release-experiments -u spectrecoin -o upload -t foo -a Artifact-A -f TheArtifactA"
//                        }
//                    }
//                }
//                stage('8') {
//                    steps {
//                        script {
//                            sh "sleep 10"
//                        }
//                    }
//                }
//                stage('9') {
//                    steps {
//                        script {
//                            sh './handleRelease.sh -r release-experiments -u spectrecoin -o edit -t foo -n "The release with release notes" -d "ReleaseNotes.md"'
//                        }
//                    }
//                }
//            }
            //noinspection GroovyAssignabilityCheck
            parallel {
                stage('Prod A') {
                    agent {
                        label "housekeeping"
                    }
                    stages {
                        stage('Remove Release if existing') {
                            when {
                                expression {
                                    return isReleaseExisting(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments'
                                    ) ==~ true
                                }
                            }
                            steps {
                                script {
                                    sh "echo Release latest found"
                                    removeRelease(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments'
                                    )
                                }
                            }
                        }
                        stage('Create Release'){
                            when {
                                expression {
                                    return isReleaseExisting(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments'
                                    ) ==~ false
                                }
                            }
                            steps {
                                script {
                                    sh "echo Release latest not found"
                                    createRelease(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments'
                                    )
                                }
                            }
                        }
                        stage('Build') {
                            steps {
                                script {
                                    sh "echo \"Building A (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-A"
                                    uploadArtifactToGitHub(
                                            user: 'spectrecoin',
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
                        stage('Remove Release if existing') {
                            when {
                                expression {
                                    return isReleaseExisting(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments',
                                            tag: "${GIT_TAG_TO_CREATE}"
                                    ) ==~ true
                                }
                            }
                            steps {
                                script {
                                    sh "echo Release foo found"
                                    removeRelease(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments',
                                            tag: "${GIT_TAG_TO_CREATE}"
                                    )
                                }
                            }
                        }
                        stage('Create Release'){
                            when {
                                expression {
                                    return isReleaseExisting(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments',
                                            tag: "${GIT_TAG_TO_CREATE}"
                                    ) ==~ false
                                }
                            }
                            steps {
                                script {
                                    sh "echo Release foo not found"
                                    sh "sleep 10"
                                    createRelease(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments',
                                            tag: "${GIT_TAG_TO_CREATE}",
                                            name: "This is the Release name",
                                            description: "Release description",
                                            preRelease: true
                                    )
                                }
                            }
                        }
                        stage('Build') {
                            steps {
                                script {
                                    sh "echo \"Building B (TimeStamp: ${currentBuild.startTimeInMillis})\" | tee Artifact-B"
                                    uploadArtifactToGitHub(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments',
                                            tag: "${GIT_TAG_TO_CREATE}",
                                            artifactNameRemote: 'Artifact-B',
                                    )
                                }
                            }
                        }
                        stage('1st update of release'){
                            steps {
                                script {
                                    sh "sleep 10"
                                    updateRelease(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments',
                                            tag: "${GIT_TAG_TO_CREATE}",
                                            name: "This is the Release name",
                                            description: "Release description",
                                            preRelease: false
                                    )
                                }
                            }
                        }
                        stage('2nd update of release'){
                            steps {
                                script {
                                    sh "sleep 10"
                                    updateRelease(
                                            user: 'spectrecoin',
                                            repository: 'release-experiments',
                                            tag: "${GIT_TAG_TO_CREATE}",
                                            name: "This is the Release from ${BUILD_NUMBER}",
                                            description: "${WORKSPACE}/ReleaseNotes.md",
                                            preRelease: true
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
                                    user: 'spectrecoin',
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
                                    user: 'spectrecoin',
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
