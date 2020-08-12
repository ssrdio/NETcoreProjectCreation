FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

COPY src/{PROJECT_NAME}.sln ./src/{PROJECT_NAME}.sln
COPY src/{PROJECT_NAME}/{PROJECT_NAME}.csproj ./src/{PROJECT_NAME}/{PROJECT_NAME}.csproj
RUN cd src; dotnet restore

COPY . ./

ARG build=Debug
RUN cd src; dotnet publish --output /app/out --configuration ${build};

# build runtime image
FROM  mcr.microsoft.com/dotnet/core/runtime:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "{PROJECT_NAME}.dll"]

