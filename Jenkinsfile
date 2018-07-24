def commitHash
def pullRequest = env.CHANGE_ID


stage('Checkout') {
    node() {
        checkout scm
        sh 'git remote remove origin && git remote add origin git@github.com:avahq/avascribe-api'
        commitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    }
}

stage('Build') {
    node() {
        try {
            githubNotify(context: "build", status: 'PENDING')
            sh 'eval "$(ssh-agent -s)" && ssh-add ~/.ssh/avascribedoc && /usr/local/bin/pip3.6 install --user -r requirements.txt --upgrade'
            sh 'eval "$(ssh-agent -s)" && ssh-add ~/.ssh/avascribedoc && PATH=$PATH:/var/lib/jenkins/.local/bin sphinx-versioning build source build/html'
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
}

stage('Deploy') {
    node() {
        if (env.CHANGE_ID) {}
        else {
            try {
                githubNotify(context: "deploy", status: 'PENDING')
                sh 'eval "$(ssh-agent -s)" && ssh-add ~/.ssh/avascribedoc && PATH=$PATH:/var/lib/jenkins/.local/bin sphinx-versioning push source gh-pages .'
            } catch(e) {
                echo "error - ${e}"
                currentBuild.result = 'FAILURE'
            } finally {
                final boolean testPassed = currentBuild.currentResult == 'SUCCESS'
                githubNotify(context: "deploy",
                            status: testPassed ? 'SUCCESS' : 'FAILURE',
                            description: 'Documentation ' + (testPassed ? ' was successfully builded' : 'failed to be build'))
            }
            try {
                githubNotify(context: "jsonschema", status: 'PENDING')
                sh "eval \"\$(ssh-agent -s)\" && ssh-add ~/.ssh/avascribedoc && bash ./create-dts-package.sh ${env.BRANCH_NAME}"
            } catch(e) {
                echo "error - ${e}"
                currentBuild.result = 'FAILURE'
            } finally {
                final boolean testPassed = currentBuild.currentResult == 'SUCCESS'
                githubNotify(context: "jsonschema",
                            status: testPassed ? 'SUCCESS' : 'FAILURE',
                            description: 'Jsonschema ' + (testPassed ? ' was successfully builded' : 'failed to be build'))
            }
        }
    }
}

stage('Clean') {
    node() {
        deleteDir()
    }
}
