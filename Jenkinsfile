pipeline {
  agent none
  stages {
    stage('Build') {
      agent{
        kubernetes {
          yamlFile './jenkins-pods/python-pod.yaml'
        }
      }
      steps {
        checkout scm

        container('python'){
          sh '''
            python --version
            cd python_app
            pip install -r requirements.txt
            cd ..
          '''
        }
      }

    }
    stage('Test') {
      agent{
        kubernetes {
          yamlFile './jenkins-pods/python-pod.yaml'
        }
      }
      steps {
        container('python'){
          sh '''
            python --version
            pip --version
            cd python_app
            pip install -r requirements.txt
            pytest test.py
          '''
        }
      }
    }
    // stage('SonarQube Analysis') {
    //   agent{
    //     kubernetes {
    //       yamlFile './jenkins-pods/sonarqube-pod.yaml'
    //     }
    //   }
    //   steps {
    //     container('sonar-scanner') {
    //       withSonarQubeEnv('sonar_qube') {
    //         sh 'sonar-scanner -Dsonar.sources=python_app'
    //       }
    //     }
    //   }
    // }
    stage('Build and Push Docker Image') {
      agent{
        kubernetes {
          yamlFile './jenkins-pods/kaniko-pod.yaml'
        }
      }
      environment {
        REGISTRY = "docker.io"
        RELEASE = "1.0.${BUILD_NUMBER}"
        APP_NAME = "python-app"
      }
      steps {
        container('kaniko') {
          withCredentials([usernamePassword(credentialsId: 'docker-registry-token', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            script {
              def IMAGE = "${DOCKER_USERNAME}/${APP_NAME}:${RELEASE}"
              sh """
                cd python_app
                /kaniko/executor \
                  --context `pwd` \
                  --dockerfile `pwd`/dockerfile \
                  --destination ${IMAGE} \
                  --oci-layout-path /kaniko/output \
                  --insecure-pull \
                  --skip-tls-verify \
                  --destination ${REGISTRY}/${IMAGE} \
              """
              env.IMAGE = "${REGISTRY}/${DOCKER_USERNAME}/${APP_NAME}"
              env.RELEASE = "${RELEASE}"
            }
          }
        }
      }
    }
    stage('Deploy to Kubernetes') {
      agent{
        kubernetes {
          yamlFile './jenkins-pods/helm-pod.yaml'
        }
      }
      steps {
        container('kubectl') {
            sh '''
            cd helmProject
            helm upgrade --install python-app ./flask-project \
            --namespace flask-helm \
            --create-namespace \
            --set image.repository=${IMAGE} \
            --set image.tag=${RELEASE}
          '''
        }
      }
    }
  }
}
