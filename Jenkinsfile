def commitHash
def pullRequest = env.CHANGE_ID


stage('Checkout') {
    node() {
        checkout scm
        commitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    }
}

stage('Build') {
    node() {
        try {
            githubNotify(context: "build", status: 'PENDING')
            sh 'pip install --user -r requirements.txt --upgrade'
            sh 'git remote -v'
            sh 'git remote remove origin'
            sh 'git remote add origin git@github.com:avahq/avascribe-api'
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
                sh 'git remote remove origin'
                sh 'git remote add origin git@github.com:avahq/avascribe-api'
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
        }
    }
}

stage('Clean') {
    node() {
        deleteDir()
    }
}
