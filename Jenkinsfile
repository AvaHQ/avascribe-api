def commitHash
def tests_image
def branchName = env.BRANCH_NAME

stage('Checkout') {
    node() {
        checkout scm
        commitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    }
}

stage('Tests') {
    node() {
        dir('.') {
            githubNotify(context: "build", status: 'PENDING', description: 'documentation is currently builded')
            image = dir('.') {
                docker.build("avascribe-api")
            }
            image.inside {
                try {
                    sh 'make html'
                } catch(e) {
                    echo "error - ${e}"
                    currentBuild.result = 'FAILURE'
                } finally {
                    final boolean testPassed = currentBuild.currentResult == 'SUCCESS'
                    githubNotify(context: "build",
                                status: testPassed ? 'SUCCESS' : 'FAILURE',
                                description: 'Documentation ' + (testPassed ? ' was successfully builded' : 'failed to be build'))
                }
            }
            sh 'ls -l'
            sh 'ls -l build'
        }
    }
}

stage('Deploy') {
    node() {
        if (branchName == "master") {
        }
    }
}

stage('Clean') {
    node() {
        deleteDir()
    }
}
