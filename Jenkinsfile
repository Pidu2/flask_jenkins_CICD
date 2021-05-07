pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = "eu-central-1"
    TAG = """${sh(
             returnStdout: true,
             script: 'date +"%Y%m%d%H%M"'
    ).trim()}"""
  }
  
  stages {
    stage("build") {
      steps{
        echo 'preparing the env'
        sh 'python3 -m venv .env'
        sh """
        . .env/bin/activate
        pip install flake8 pytest
        pip install -r requirements.txt
        """
      }
    }

    stage("test") {
      steps{
        echo 'testing the app'
        sh """
        . .env/bin/activate
        flake8 *.py --count --show-source --statistics
        pytest -v
        """
      }
    }

    stage("build & push") {
      steps{
        echo 'pushing the app'
        withCredentials([usernamePassword(credentialsId: 'webapp_test_jenkins', usernameVariable: 'NUSER', passwordVariable: 'NPASS')]) {
          sh 'echo ${NPASS} | docker login -u ${NUSER} --password-stdin'
        }
        sh """
        #=\$(date +"%Y%m%d%H%M")
        docker build . -t pidu2/webapp_test:\$TAG
        docker push pidu2/webapp_test:\$TAG
        """
      }
    }

    stage("deploy") {
      steps{
        echo 'deploying the app'
        //sh 'rm -f terraform terraform*.zip;wget https://releases.hashicorp.com/terraform/0.15.0/terraform_0.15.0_linux_amd64.zip;unzip terraform_0.15.0_linux_amd64.zip;rm terraform_0.15.0_linux_amd64.zip' 
        withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh "terraform init -input=false"
          sh "terraform apply -auto-approve"
          script {
            env.eip=sh(script:'terraform output eip', returnStdout: true).trim().replaceAll('"','')
          }
        }
        sh 'echo ip is: ${eip}'
        ansiblePlaybook become: true, credentialsId: 'deployment_key', disableHostKeyChecking: true, installation: 'ansible', playbook: 'deploy.yml', extraVars: [webapp_test_version: '${TAG}'], inventory: '${eip},'
      }
    }

  }
}
