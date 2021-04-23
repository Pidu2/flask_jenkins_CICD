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

    stage("push") {
      steps{
        echo 'pushing the app'
        sh """
        tag=$(date +"%Y%m%d%H%M")
        docker build -t pidu2/webapp_test:$tag
        """
      }
    }

    stage("deploy") {
      steps{
        echo 'deploying the app'
      }
    }

  }
}
