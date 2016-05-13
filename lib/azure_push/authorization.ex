defmodule AzurePush.Authorization do
  def token(url, key_name, access_key, lifetime \\ 10) do
    target_uri = target_uri(url)
    expires = expires(lifetime)
    to_sign = to_sign(target_uri, expires)
    signature = signature(access_key, to_sign)
    "SharedAccessSignature sr=#{target_uri}&sig=#{signature}&se=#{expires}&skn=#{key_name}"
  end

  defp target_uri(url) do
    url = url
    |> String.downcase
    |> URI.encode_www_form
    |> (&(Regex.replace(~r/\+/, &1, "%20", global: true))).()
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
    |> (&(Regex.replace(~r/\+/, &1, "%20", global: true))).()
  end
end
