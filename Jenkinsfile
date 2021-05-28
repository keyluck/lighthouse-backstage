#!groovy
import groovy.json.JsonOutput
/*

 GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          ARCHIVE_DOWNLOAD_URL: ${{ env.ARCHIVE_DOWNLOAD_URL }}
          TECHDOCS_S3_BUCKET_NAME: ${{ secrets.TECHDOCS_S3_BUCKET_NAME }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: ${{ secrets.AWS_REGION }}
          ENTITY: ${{ github.event.inputs.entity }}
          */

node {
  fetchAndUnzip()
  sh "ls -a archive"
}

def fetchAndUnzip
{
  stage ('Fetch and unzip') {
    sh("curl -s --output ./archive.zip -H \"Authorization: Token ${env.GITHUB_TOKEN}\" -H \"Accept: application/json\" -H \"Content-type: application/json\" -X GET ${apiUrl}")
    sh "unzip archive.zip"
  }
}
