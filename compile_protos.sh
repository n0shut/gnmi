#!/bin/sh

# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

# Go
if ! which protoc-gen-go-grpc; then
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
fi
protobufsrc=${GOPATH}/src/github.com/google/protobuf/src
googleapis=${GOPATH}/src/github.com/googleapis/googleapis
proto_imports_go=".:${protobufsrc}:${googleapis}:${GOPATH}/src"
protoc -I=$proto_imports_go --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative,require_unimplemented_servers=false testing/fake/proto/fake.proto
protoc -I=$proto_imports_go --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative,require_unimplemented_servers=false proto/gnmi/gnmi.proto
protoc -I=$proto_imports_go --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative,require_unimplemented_servers=false proto/collector/collector.proto
protoc -I=$proto_imports_go --go_out=. --go_opt=paths=source_relative proto/gnmi_ext/gnmi_ext.proto
protoc -I=$proto_imports_go --go_out=. --go_opt=paths=source_relative proto/target/target.proto

# Python
proto_imports_python=".:${GOPATH}/src"
python3 -m grpc_tools.protoc -I=$proto_imports_python --python_out=. --grpc_python_out=. testing/fake/proto/fake.proto
python3 -m grpc_tools.protoc -I=$proto_imports_python --python_out=. --grpc_python_out=. proto/gnmi/gnmi.proto
python3 -m grpc_tools.protoc -I=$proto_imports_python --python_out=. --grpc_python_out=. proto/gnmi_ext/gnmi_ext.proto
python3 -m grpc_tools.protoc -I=$proto_imports_python --python_out=. --grpc_python_out=. proto/target/target.proto
python3 -m grpc_tools.protoc -I=$proto_imports_python --python_out=. --grpc_python_out=. proto/collector/collector.proto
