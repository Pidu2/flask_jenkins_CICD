pipeline {
  agent any

  stages {

    stage("build") {
      steps{
        echo 'preparing the env'
        sh 'python3 -m venv .env'
        sh """
        . .env/bin/activate
        pip install flake8 pytest
        sudo pip install -r requirements.txt
        """
      }
    }

    stage("test") {
      steps{
        echo 'testing the app'
      }
    }

    stage("push") {
      steps{
        echo 'pushing the app'
      }
    }

    stage("deploy") {
      steps{
        echo 'deploying the app'
      }
    }

  }
}
