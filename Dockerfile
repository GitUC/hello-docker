FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["HelloDocker.csproj", "./"]
RUN dotnet restore "./HelloDocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HelloDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloDocker.dll"]
