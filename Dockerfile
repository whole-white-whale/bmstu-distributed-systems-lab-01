FROM haskell:latest
COPY ./personenregistrirungssystem/. /personenregistrirungssystem
WORKDIR /personenregistrirungssystem
RUN apt update && apt install -y libpq-dev
RUN stack build --install-ghc
EXPOSE 8080
ENTRYPOINT ["stack", "exec", "personenregistrirungssystem-server"]
