// Copyright 2019 The UFO Team
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

#include "swap_coin_client_model.h"

#include "model/app_model.h"
#include "wallet/common.h"
#include "wallet/swaps/common.h"
#include "wallet/bitcoin/bitcoin_core_017.h"
#include "wallet/bitcoin/settings_provider.h"

using namespace ufo;

namespace
{
    const int kUpdateInterval = 10000;
}

SwapCoinClientModel::SwapCoinClientModel(ufo::bitcoin::IBridgeHolder::Ptr bridgeHolder,
    std::unique_ptr<ufo::bitcoin::SettingsProvider> settingsProvider,
    io::Reactor& reactor)
    : bitcoin::Client(bridgeHolder, std::move(settingsProvider), reactor)
    , m_timer(this)
{
    qRegisterMetaType<ufo::bitcoin::Client::Status>("ufo::bitcoin::Client::Status");
    qRegisterMetaType<ufo::bitcoin::Client::Balance>("ufo::bitcoin::Client::Balance");

    connect(&m_timer, SIGNAL(timeout()), this, SLOT(requestBalance()));

    // connect to myself for save values in UI(main) thread
    connect(this, SIGNAL(gotBalance(const ufo::bitcoin::Client::Balance&)), this, SLOT(setBalance(const ufo::bitcoin::Client::Balance&)));
    connect(this, SIGNAL(gotStatus(ufo::bitcoin::Client::Status)), this, SLOT(setStatus(ufo::bitcoin::Client::Status)));
    connect(this, SIGNAL(gotCanModifySettings(bool)), this, SLOT(setCanModifySettings(bool)));

    requestBalance();

    m_timer.start(kUpdateInterval);

    GetAsync()->GetStatus();
}

ufo::Amount SwapCoinClientModel::getAvailable()
{
    return m_balance.m_available;
}

void SwapCoinClientModel::OnStatus(Status status)
{
    emit gotStatus(status);
}

ufo::bitcoin::Client::Status SwapCoinClientModel::getStatus() const
{
    return m_status;
}

bool SwapCoinClientModel::canModifySettings() const
{
    return m_canModifySettings;
}

void SwapCoinClientModel::OnBalance(const bitcoin::Client::Balance& balance)
{
    emit gotBalance(balance);
}

void SwapCoinClientModel::OnCanModifySettingsChanged(bool canModify)
{
    emit gotCanModifySettings(canModify);
}

void SwapCoinClientModel::OnChangedSettings()
{
    requestBalance();
}

void SwapCoinClientModel::requestBalance()
{
    if (GetSettings().IsActivated())
    {
        // update balance
        GetAsync()->GetBalance();
    }
}

void SwapCoinClientModel::setBalance(const ufo::bitcoin::Client::Balance& balance)
{
    if (m_balance != balance)
    {
        m_balance = balance;
        emit balanceChanged();
    }
}

void SwapCoinClientModel::setStatus(ufo::bitcoin::Client::Status status)
{
    if (m_status != status)
    {
        m_status = status;
        emit statusChanged();
    }
}

void SwapCoinClientModel::setCanModifySettings(bool canModify)
{
    if (m_canModifySettings != canModify)
    {
        m_canModifySettings = canModify;
        emit canModifySettingsChanged();
    }
}
