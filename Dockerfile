FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

COPY src/{PROJECT_NAME}.sln ./src/{PROJECT_NAME}.sln
COPY src/{PROJECT_NAME}/{PROJECT_NAME}.csproj ./src/{PROJECT_NAME}/{PROJECT_NAME}.csproj
RUN cd src; dotnet restore

COPY . ./

ARG build=Debug
RUN cd src; dotnet publish --output /app/out --configuration ${build};

# build runtime image
FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "{PROJECT_NAME}.dll"]