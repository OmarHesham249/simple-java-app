pipeline {
    agent any

    tools {
        maven 'M3916'
    }

    stages {
        // سيبنا الـ Fetch لكودك أنت عشان نضمن إنه بيبني من الريبو الصح
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
                
                // هنا بننده على الـ Credentials اللي عملناها في جينكنز
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    
                    // 1. بنبني الإيميج بـ الاسم بتاعك أنت
                    sh "docker build -t ${USERNAME}/simple-java-app:latest ."
                    
                    // 2. بنسجل دخول على السيرفر أوتوماتيك
                    sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                    
                    // 3. بنرفع الإيميج على حسابك في دوكر هب
                    sh "docker push ${USERNAME}/simple-java-app:latest"
                }
            }
        }

        stage('5. Deploy') {
            steps {
                echo 'Deploying Application to Production...'
                sh 'docker stop my-running-app || true'
                sh 'docker rm my-running-app || true'

                // تشغيل الكونتينر من الإيميج بتاعتك أنت بعد ما اتصبت على السيرفر
                sh 'docker run -d --name my-running-app -p 8081:8080 omarhesham249/simple-java-app:latest'
                echo 'Application is live on port 8081!'
            }
        }
    }
}
