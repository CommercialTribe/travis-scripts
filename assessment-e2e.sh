#!/usr/bin/env bash
set -e

echo "Starting Assessment End-To-End Tests"
echo "Images:"
echo " assessment-e2e: ${IMAGE_E2E}"
echo " assessment-frontend: ${IMAGE_ASSESSMENT_FRONTEND}"
echo " assessment-api: ${IMAGE_ASSESSMENT_API}"

# Prep variables
imageAssessmentApiLatest="${DOCKER_BASE_IMAGE_PATH}/assessment-api:latest"
assessmentApiContainerName=e2e-assessment-api
e2eLogsDirPath=e2e/logs

authHeader="Authorization: token ${GITHUB_API_TOKEN}"
acceptHeader='Accept: application/vnd.github.v3.raw'
githubUrlPrefix=https://api.github.com/repos/CommercialTribe
dockerComposeFile=docker-compose-e2e.yml

# Download needed files
echo "Getting ${dockerComposeFile}"
dockerComposeE2e="${githubUrlPrefix}/assessment-e2e/contents/${dockerComposeFile}"
curl -H "${authHeader}" -H "${acceptHeader}" -sSL ${dockerComposeE2e} > ${dockerComposeFile}

echo "Getting assessment-api .env.docker"
assessmentApiEnv="${githubUrlPrefix}/assessment-api/contents/.env.docker"
curl -H "${authHeader}" -H "${acceptHeader}" -sSL ${assessmentApiEnv} > assessment-api.env

# Init and run tests
echo "Bootstrapping db"
IMAGE_ASSESSMENT_API="${imageAssessmentApiLatest}" docker-compose -f ${dockerComposeFile} run assessment-api yarn db:bootstrap
echo "Running e2e tests"
set +e
docker-compose -f ${dockerComposeFile} run e2e
e2eExitCode=$?
if [ ${e2eExitCode} -ne 0 ]
then
  set -e
  echo "e2e tests failed. Writing assessment-api logs for upload to S3"
  mkdir -p ${e2eLogsDirPath}
  docker logs ${assessmentApiContainerName} > "${e2eLogsDirPath}/${assessmentApiContainerName}.txt"
  exit ${e2eExitCode}
fi

set -e
echo "Assessment End-To-End Tests Done"
