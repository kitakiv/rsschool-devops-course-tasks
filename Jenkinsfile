pipeline {
  agent none
  environment {
        REGISTRY = "docker.io"
        RELEASE = "1.0.${BUILD_NUMBER}"
        APP_NAME = "python-app"
        PATH_TO_HELM_PROJECT = "./helmProject/flask-project"
        NAMESPACE = "flask-helm"
        HELM_FOLDER = "flask-project"
      }
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
            cd ${APP_NAME}
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
            cd ${APP_NAME}
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
      steps {
        container('kaniko') {
          withCredentials([usernamePassword(credentialsId: 'docker-registry-token', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            script {
              def IMAGE = "${DOCKER_USERNAME}/${APP_NAME}:${RELEASE}"
              sh """
                cd ${APP_NAME}
                /kaniko/executor \
                  --context `pwd` \
                  --dockerfile `pwd`/dockerfile \
                  --destination ${IMAGE} \
                  --oci-layout-path /kaniko/output \
                  --insecure-pull \
                  --skip-tls-verify \
                  --destination ${REGISTRY}/${IMAGE} \
              """
              env.IMAGE = "${REGISTRY}/${DOCKER_USERNAME}/${APP_NAME}:${RELEASE}"
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
           withCredentials([file(credentialsId: 'kubeconfig-dev', variable: 'KUBECONFIG_FILE')]) {
            sh '''
              mkdir -p ~/.kube
              rm -f ~/.kube/config
              cp "$KUBECONFIG_FILE" ~/.kube/config
              helm upgrade --install ${APP_NAME} ${PATH_TO_HELM_PROJECT} \
            --namespace flask-helm \
            --create-namespace \
            --set image.repository=${IMAGE}
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            chmod +x kubectl
            mv kubectl /usr/local/bin/
            kubectl version --client
            '''
            script {
              def NODE_PORT = sh(script: "kubectl get --namespace ${NAMESPACE} -o jsonpath="{.spec.ports[0].nodePort}" services ${APP_NAME}-${HELM_FOLDER}", returnStdout: true).trim()
              def NODE_IP = sh(script: "kubectl get nodes --namespace ${NAMESPACE} -o jsonpath="{.items[0].status.addresses[0].address}"", returnStdout: true).trim()
              env.URL = "http://${NODE_IP}:${NODE_PORT}"
            }
          }
        }
      }
    }
    stage("Smoke tests") {
      agent any
      steps {
        script {
           sh """
           echo "Running smoke test on: ${URL}"
           sleep 10
           curl --fail --retry 5 --retry-delay 5 ${URL}
           """
        }
      }
    }
  }
}
