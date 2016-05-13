defmodule AzurePush.Authorization do
  alias AzurePush.Message

  def token(%Message{}=message, url) do
    target_uri = target_uri(url)
    expires = expires(message.sig_lifetime)
    to_sign = to_sign(target_uri, expires)
    signature = signature(message.access_key, to_sign)
    "SharedAccessSignature sr=#{target_uri}&sig=#{signature}&se=#{expires}&skn=#{message.key_name}"
  end

  defp target_uri(url) do
    url = url
    |> String.downcase
    |> URI.encode_www_form
    |> escape_plus
  end

  defp expires(lifetime) do
    :os.system_time(:seconds) + lifetime
  end

  defp to_sign(target_uri, expires) do
    "#{target_uri}\n#{expires}"
  end

  defp signature(access_key, to_sign) do
    :crypto.hmac(:sha256, access_key, to_sign)
    |> Base.encode64
    |> URI.encode_www_form
    |> escape_plus
  end

  defp escape_plus(string) do
    Regex.replace(~r/\+/, string, "%20", global: true)
  end
end
