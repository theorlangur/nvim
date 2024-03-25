local utils = require('dap.utils')

local rpc = require('dap.rpc')

local function send_payload(client, payload)
  local msg = rpc.msg_with_content_length(vim.json.encode(payload))
  client.write(msg)
end

function RunHandshake(self, request_payload)
  vim.print("RunHandshake: ", request_payload)
  local signResult = io.popen('node d:\\Developing\\devenv\\vsdbg_adapter\\signature\\sign.js ' .. request_payload.arguments.value)
  if signResult == nil then
    utils.notify('error while signing handshake', vim.log.levels.ERROR)
    return
  end
  local signature = signResult:read("*a")
  vim.print("RunHandshake raw sig: ", signature)
  signature = string.gsub(signature, '\n', '')
  local response = {
    type = "response",
    seq = 0,
    command = "handshake",
    request_seq = request_payload.seq,
    success = true,
    body = {
      signature = signature
    }
  }
  vim.print("RunHandshake resp: ", response)
  send_payload(self.client, response)
end
return RunHandshake
