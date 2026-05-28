-- Dockerfile snippets: language-specific base images.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("df_python", fmt([[
FROM python:{ver}-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

EXPOSE {port}
CMD ["python", "{entry}"]
]], { ver = i(1, "3.12"), port = i(2, "8000"), entry = i(3, "main.py") })),

  s("df_node", fmt([[
FROM node:{ver}-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .

EXPOSE {port}
CMD ["node", "{entry}"]
]], { ver = i(1, "20"), port = i(2, "3000"), entry = i(3, "index.js") })),

  s("df_go_multistage", fmt([[
FROM golang:{ver}-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /out/{bin} ./{pkg}

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /out/{bin} /{bin}
EXPOSE {port}
ENTRYPOINT ["/{bin}"]
]], { ver = i(1, "1.23"), bin = i(2, "app"), pkg = i(3, "cmd/app"), port = i(4, "8080") })),

  s("df_java", fmt([[
FROM eclipse-temurin:{ver}-jre

WORKDIR /app
COPY {jar} app.jar

EXPOSE {port}
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
]], { ver = i(1, "21"), jar = i(2, "target/*.jar"), port = i(3, "8080") })),
}
