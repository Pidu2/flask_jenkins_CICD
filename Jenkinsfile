pipeline {
  agent {
    docker 'python:3.8.6'
  }

  stages {

    stage("build") {
      steps{
        echo 'preparing the env'
        sh 'python -m pip install --upgrade pip'
        sh 'python -m pip install flake8 pytest'
        sh 'pip install -r requirements.txt'
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
