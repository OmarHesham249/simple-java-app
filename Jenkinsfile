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
                
                // غيرنا اسم المتغير الداخلي لـ DOCKER_PASS عشان يقرأ نضيف 
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    
                    echo 'Building Docker Image...'
                    sh 'docker build -t $DOCKER_USER/simple-java-app:latest .'
                    
                    echo 'Logging into Docker Hub...'
                    // السنجل كوتس برة إجباري عشان السيرفر يمرر التوكن صح للـ stdin
                    sh 'echo "$DOCKER_PASS" | docker login -u $DOCKER_USER --password-stdin'
                    
                    echo 'Pushing Image to Docker Hub...'
                    sh 'docker push $DOCKER_USER/simple-java-app:latest'
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
