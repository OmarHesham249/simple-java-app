pipeline {
    agent any
    
    tools {
        // هنا بنقول لجينكينز استخدم المافن اللي إحنا لسه مسميينه M3 فوق
        maven 'M3916'
    }

    stages {
        stage('1. Fetch Code') {
            steps {
                echo 'Fetching Code from GitHub...'
                // هنا بنسحب الكود من اللينك بتاعك
                git branch: 'main', url: 'https://github.com/HaythamMohamd/simple-java-app.git'
            }
        }

        stage('2. Build') {
            steps {
                echo 'Building Java Application using Maven...'
                // أمر مافن عشان يترجم الكود ويجهز الملفات بدون ما يشغل الـ tests في الخطوة دي
                sh 'mvn clean compile'
            }
        }

        stage('3. Test') {
            steps {
                echo 'Running Unit Tests...'
                // أمر مافن لتشغيل الاختبارات وعمل الـ Package النهائي (.jar)
                sh 'mvn test package'
            }
        }

        stage('4. Push (Docker Image)') {
            steps {
                echo 'Building Docker Image and Pushing...'
                /* هنا جينكينز بيستخدم الـ docker.sock اللي ربطناه زمان 
                عشان يعمل إيميج للأبلكيشن بتاعك ويسميها باسمك
                */
                sh 'docker build -t haythammohamd/simple-java-app:latest .'
                
                // ملحوظة: عشان تعمل Push فعلي للـ Docker Hub هتحتاج تظبط الباسورد، 
                // بس كبداية السطر ده هيبني الإيميج عندك على السيرفر بنجاح.
            }
        }

        stage('5. Deploy') {
            steps {
                echo 'Deploying Application to Production...'
                // بنوقف أي كونتينر قديم بنفس الاسم عشان ميعملش تعارض
                sh 'docker stop my-running-app || true'
                sh 'docker rm my-running-app || true'
                
                // بنشغل الأبلكيشن الجديد على بورت 80 مثلاً أو 8081
                sh 'docker run -d --name my-running-app -p 8081:8080 haythammohamd/simple-java-app:latest'
                echo 'Application is live on port 8081!'
            }
        }
    }
}
