FROM public.ecr.aws/lambda/dotnet:5.0 AS base

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim as build
WORKDIR /build
COPY ["./src/Ticker/Ticker.csproj", "src/Ticker/"]
RUN dotnet restore "src/Ticker/Ticker.csproj"
COPY ["./src/Ticker/", "src/Ticker/"]
WORKDIR "/build/src/Ticker"
RUN dotnet build "Ticker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Ticker.csproj" --configuration Release --output /app/publish --runtime linux-x64 --self-contained false -p:PublishReadyToRun=true

FROM base AS final
WORKDIR /var/task
COPY --from=publish /app/publish .
CMD ["Ticker::Ticker.Function::FunctionHandlerAsync"]