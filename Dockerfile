FROM  --platform=linux/amd64 mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 7128

ENV ASPNETCORE_URLS=http://+:7128

FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Domain/Domain.csproj", "Domain/"]
COPY ["Application/Application.csproj", "Application/"]
COPY ["WebAPI/WebAPI.csproj", "WebAPI/"]
COPY ["EfcDataAccess/EfcDataAccess.csproj", "EfcDataAccess/"]

COPY . .
WORKDIR "/src/WebAPI"
RUN dotnet build "WebAPI.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app
COPY --from=build /src/EfcDataAccess/Greenhouse2.db /app

FROM base AS final
RUN mkdir /Database
WORKDIR /app
COPY --from=publish /app .
COPY start.sh /
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
