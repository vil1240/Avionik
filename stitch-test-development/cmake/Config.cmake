cmake_minimum_required(VERSION 3.18.0)

# Set project name
set(LOCAL_PROJECT_NAME stitch-test)
set(LOCAL_PROJECT_NAMESPACE thi-sensor-fusion)
set(LOCAL_PROJECT_NAME_FULL ${LOCAL_PROJECT_NAMESPACE}_${LOCAL_PROJECT_NAME})
set(LOCAL_PROJECT_DESCRIPTION "C/C++ template")

string(TOUPPER ${LOCAL_PROJECT_NAME} LOCAL_PROJECT_NAME_CAPS)
string(REPLACE "-" "_" LOCAL_PROJECT_NAME_CAPS ${LOCAL_PROJECT_NAME_CAPS})
string(TOUPPER ${LOCAL_PROJECT_NAMESPACE} LOCAL_PROJECT_NAMESPACE_CAPS)
string(REPLACE "-" "_" LOCAL_PROJECT_NAMESPACE_CAPS ${LOCAL_PROJECT_NAMESPACE_CAPS})
string(TOUPPER ${LOCAL_PROJECT_NAME_FULL} LOCAL_PROJECT_NAME_FULL_CAPS)
string(REPLACE "-" "_" LOCAL_PROJECT_NAME_FULL_CAPS ${LOCAL_PROJECT_NAME_FULL_CAPS})

# Set project paths.
string(REPLACE "_" "/" LOCAL_PROJECT_PATH ${LOCAL_PROJECT_NAMESPACE})
string(REPLACE "_" "/" LOCAL_PROJECT_PATH_FULL ${LOCAL_PROJECT_NAME_FULL})