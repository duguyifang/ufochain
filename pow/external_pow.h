// Copyright 2018 The Ufo Team
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma once
#include "core/block_crypt.h"
#include "utility/io/reactor.h"

namespace ufo {

class IExternalPOW {
public:
    enum BlockFoundResultCode { solution_accepted, solution_rejected, solution_expired };
    
    struct BlockFoundResult {
        BlockFoundResult(BlockFoundResultCode code) : _code(code) {}
        virtual ~BlockFoundResult() = default;

        bool operator ==(BlockFoundResultCode code) { return _code == code; }
        bool operator !=(BlockFoundResultCode code) { return _code != code; }

        BlockFoundResultCode _code;
        std::string _blockhash;
    };

    using BlockFound = std::function<BlockFoundResult()>;

    using CancelCallback = std::function<bool()>;

    struct Options {
        std::string apiKeysFile;
        std::string certFile;
        std::string privKeyFile;
    };

    // creates stratum server
    static std::unique_ptr<IExternalPOW> create(
        const Options& o, io::Reactor& reactor, io::Address listenTo, unsigned noncePrefixDigits
    );

    // creates local solver (stub)
    static std::unique_ptr<IExternalPOW> create_local_solver(bool fakeSolver);

    static std::unique_ptr<IExternalPOW> create_opencl_solver(const std::vector<int32_t>& devices);

    virtual ~IExternalPOW() = default;

    virtual void new_job(
        const std::string& jobID,
        const Merkle::Hash& prev,
        const Merkle::Hash& input,
        const Block::PoW& pow,
        const Height& height,
        const BlockFound& callback,
        const CancelCallback& cancelCallback) = 0;

    virtual void get_last_found_block(std::string& jobID, Height& jobHeight, Block::PoW& pow) = 0;

    virtual void stop_current() = 0;

    virtual void stop() = 0;
};


class IExternalPOW2 {
public:
    enum ShareFoundResultCode { solution_accepted, solution_rejected, solution_expired };

    struct ShareFoundResult {
        ShareFoundResult(ShareFoundResultCode code) : _code(code) {}
        virtual ~ShareFoundResult() = default;

        bool operator ==(ShareFoundResultCode code) { return _code == code; }
        bool operator !=(ShareFoundResultCode code) { return _code != code; }

        ShareFoundResultCode _code;
        std::string _blockhash;
    };

    using ShareFound = std::function<ShareFoundResult()>;

    using CancelCallback = std::function<bool()>;

    struct Options {
        std::string apiKeysFile;
        std::string certFile;
        std::string privKeyFile;
    };

    // creates stratum server
    static std::unique_ptr<IExternalPOW2> create(
        const Options& o, io::Reactor& reactor, io::Address listenTo, unsigned noncePrefixDigits
    );

    // creates local solver (stub)
    static std::unique_ptr<IExternalPOW2> create_local_solver(bool fakeSolver);

    static std::unique_ptr<IExternalPOW2> create_opencl_solver(const std::vector<int32_t>& devices);

    virtual ~IExternalPOW2() = default;

    virtual void new_job(
        const std::string& jobID,
        const Merkle::Hash& prev,
        const Merkle::Hash& input,
        const Difficulty& setDiff,
        Height height,
        const ShareFound& callback,
        const CancelCallback& cancelCallback) = 0;

    virtual void set_enonce(const std::string& enonceStr) = 0;

    virtual void reset_seed() = 0;

    virtual void get_last_found_share(std::string& jobID, Block::PoW& pow) = 0;

    virtual void stop_current() = 0;

    virtual void stop() = 0;
};


} //namespace
