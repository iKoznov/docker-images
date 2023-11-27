#ARG BASE_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2019
ARG BASE_IMAGE=amitie10g/msys2:latest
FROM ${BASE_IMAGE}

ARG CHOCO_URL=https://chocolatey.org/install.ps1
RUN powershell Set-ExecutionPolicy Bypass -Scope Process -Force; \
 [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; \
 iex ((New-Object System.Net.WebClient).DownloadString("$env:CHOCO_URL"))

# list of visual studio installer componets IDs
# https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2019#desktop-development-with-c
# https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2019
# https://learn.microsoft.com/en-us/visualstudio/install/command-line-parameter-examples?view=vs-2019
#COPY chocolatey.config .
#RUN powershell choco install chocolatey.config -y --no-progress
#RUN powershell choco install msys2 -y --no-progress
#RUN powershell refreshenv
#RUN env
#RUN mingw64 --version
