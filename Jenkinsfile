pipeline {

    agent any

    // Define when to check for changes
    // Based on documentation, found at:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#triggers
    triggers {
        pollSCM('H/1 * * * *')
    }

    options {
        disableConcurrentBuilds()
    }

    stages() {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage("Refresh Docker") {
            steps {
                sh 'if [[ -n "$(docker container ls -aq)" ]]; then docker container stop $(docker container ls -aq); fi \
                && docker builder prune -f && docker system prune -af'
            }
        }
        stage('Build Image') {
            steps {
                script {
                    sh 'docker build -t cw2-server .'
                }
            }
        }
        stage('Test Image') {
            steps {
                sh 'docker run -d --name cw2-server -p 8081:8081 cw2-server'
                sh 'echo "$(docker exec -it cw2-server sh -c echo)"'
                sh "curl -f http://localhost:8081"
            }
        }
        stage('Bump Version') {
            steps {
                sh 'npm version patch --git-tag-version false && NODE_VERSION=$(jq -r .version package.json)'
                sh 'echo "New version: $NODE_VERSION"'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Commit Version') {
            steps {
                sh 'git add package.json && git commit -m "Bump version" && git push'
            }
        }
    }

    post {
        always {
            // Always clean up resources and purge images once finished
            sh 'docker builder prune -f && docker system prune -af'
        }
        success {
            steps {
                echo 'Build and deployment successful!'
            }
        }
        failure {
            sh "Build and Deployment Failed!"
        }

    }

}