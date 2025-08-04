pipeline {

    agent any

    // Define when to check for changes
    // Based on documentation, found at:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#triggers
    triggers {
        pollSCM('* * * * *')
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
        stage('Build Image') {
            steps {
                script {
                    app = docker.build('mpirouet/cw2-server')
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
        stage('Bump version') {
            steps {
                sh 'npm version minor'
                sh 'git add package.json'
                sh 'git commit -m "Bump version to $(jq -r .version package.json)"'
                sh 'git push origin main'
            }

        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry() {
                        app.push('$(jq -r .version package.json)')
                        app.push('latest')
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sshagent(credentials: ['prd-ssh-key']) {
                    sh 'ssh ubuntu@172.31.33.75'
                    sh 'hostname'
                }
                sh ''
            }
        }
    }

    post {
        always {
            // Always clean up resources and purge images once finished
            sh 'docker stop cw2-server'
            sh 'docker builder prune -f && docker system prune -af'
        }
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            sh "Build and Deployment Failed!"
        }

    }

}