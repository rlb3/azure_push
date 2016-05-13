defmodule AzurePush.Message do
  alias AzurePush.Authorization, as: Auth

  defstruct [:namespace, :hub, :access_key, key_name: "DefaultFullSharedAccessSignature", sig_lifetime: 10]

  def new(namespace, hub, access_key) do
    %AzurePush.Message{namespace: namespace, access_key: access_key, hub: hub}
  end

  def send(message, payload, tags \\ [], format \\ "apple") do
    json_payload = Poison.encode! payload
    url = url(message.namespace, message.hub)
    content_type = "application/json"
    headers = [
      {"Content-Type", content_type},
      {"Authorization", Auth.token(url, message.key_name, message.access_key, message.sig_lifetime)},
      {"ServiceBusNotification-Format", format}
    ]
    request(url, json_payload, headers)
  end

  defp url(namespace, hub) do
    "https://#{namespace}.servicebus.windows.net/#{hub}/messages"
  end

  defp request(url, payload, headers) do
    case HTTPoison.post(url, payload, headers) do
      {:ok, %HTTPoison.Response{status_code: 201}} ->
        {:ok, :sent}
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, :unauthenticated}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
