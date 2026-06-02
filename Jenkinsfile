pipeline {
    agent any

    tools {
        // تعريف نسخة المافن المتسطبة عندك في جينكينز
        maven 'M3916'
    }

    stages {
        stage('1. Fetch Code') {
            steps {
                echo 'Fetching Code from GitHub...'
                // سحب الكود من الريبو بتاعك أنت الحقيقي
                git branch: 'main', url: 'https://github.com/OmarHesham249/simple-java-app'
            }
        }

        stage('2. Build') {
            steps {
                echo 'Building Java Application using Maven...'
                // عمل clean و compile للكود بناءً على pom.xml المعدل (Java 8)
                sh 'mvn clean compile'
            }
        }

        stage('3. Test') {
            steps {
                echo 'Running Unit Tests and Packaging...'
                // تشغيل التستس وتجميع الملف النهائي (.jar) في فولدر target
                sh 'mvn test package'
            }
        }

        stage('4. Push (Docker Image)') {
            steps {
                echo 'Building Docker Image and Pushing to Docker Hub...'
                
                // استدعاء الـ Credentials اللي عملناها باسم dockerhub-creds
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    
                    echo 'Building Docker Image...'
                    sh "docker build -t ${USERNAME}/simple-java-app:latest ."
                    
                    echo 'Logging into Docker Hub...'
                    // تسجيل الدخول بالطريقة الآمنة اللي هتحل إيرور الـ Authorization Header
                    sh "echo '${PASSWORD}' | docker login -u ${USERNAME} --password-stdin"
                    
                    echo 'Pushing Image to Docker Hub...'
                    sh "docker push ${USERNAME}/simple-java-app:latest"
                }
            }
        }

        stage('5. Deploy') {
            steps {
                echo 'Deploying Application to Production...'
                // إيقاف ومسح أي كونتينر قديم شغال بنفس الاسم عشان ما يحصلش تعارض في البورتات
                sh 'docker stop my-running-app || true'
                sh 'docker rm my-running-app || true'

                echo 'Starting the new container...'
                // تشغيل الكونتينر الجديد من الإيميج بتاعتك اللي لسه مرفوعة حالا
                sh 'docker run -d --name my-running-app -p 8081:8080 omarhesham249/simple-java-app:latest'
                
                echo '✅ Success! Application is live on port 8081!'
            }
        }
    }
}
