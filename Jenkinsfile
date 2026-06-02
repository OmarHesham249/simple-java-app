pipeline {
    agent any

    tools {
        maven 'M3916'
    }

    stages {
        stage('1. Fetch Code') {
            steps {
                echo 'Fetching Code from GitHub...'
                git branch: 'main', url: 'https://github.com/OmarHesham249/simple-java-app'
            }
        }

        stage('2. Build') {
            steps {
                echo 'Building Java Application using Maven...'
                sh 'mvn clean compile'
            }
        }

        stage('3. Test') {
            steps {
                echo 'Running Unit Tests and Packaging...'
                sh 'mvn test package'
            }
        }

        stage('4. Push (Docker Image)') {
            steps {
                echo 'Building Docker Image and Pushing to Docker Hub...'
                
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        
                        echo 'Building Docker Image...'
                        def myImage = docker.build("omarhesham249/simple-java-app:latest", ".")
                        
                        echo 'Pushing Image to Docker Hub...'
                        myImage.push()
                    }
                }
            }
        }

        stage('5. Deploy') {
            steps {
                echo 'Deploying Application to Production...'
                sh 'docker stop my-running-app || true'
                sh 'docker rm my-running-app || true'

                echo 'Starting the new container...'
                sh 'docker run -d --name my-running-app -p 8081:8080 omarhesham249/simple-java-app:latest'
                
                echo '✅ Success! Application is live on port 8081!'
            }
        }
    }
}
