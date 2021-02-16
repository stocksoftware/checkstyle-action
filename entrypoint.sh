#!/bin/sh

echo "Running Checkstyle"
echo "INPUT_TOOL_NAME=${INPUT_TOOL_NAME}"
echo "INPUT_REPORTER=${INPUT_REPORTER}"
echo "INPUT_FILTER_MODE=${INPUT_FILTER_MODE}"
echo "INPUT_FAIL_ON_ERROR=${INPUT_FAIL_ON_ERROR}"
echo "INPUT_LEVEL=${INPUT_LEVEL}"
echo "INPUT_WORKDIR=${INPUT_WORKDIR}"
echo "INPUT_CHECKSTYLE_CONFIG=${INPUT_CHECKSTYLE_CONFIG}"
echo "INPUT_PROPERTIES_FILE=${INPUT_PROPERTIES_FILE}"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ -n "${INPUT_PROPERTIES_FILE}" ]; then
  OPT_PROPERTIES_FILE="-p ${INPUT_PROPERTIES_FILE}"
fi

cd $INPUT_WORKDIR
exec java "-Dbasedir=${`pwd`}" -jar /checkstyle.jar "${INPUT_WORKDIR}" -c "${INPUT_CHECKSTYLE_CONFIG}" ${OPT_PROPERTIES_FILE} -f xml \
 | reviewdog -f=checkstyle \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
      -level="${INPUT_LEVEL}"
