%%--------------------------------------------------------------------
%% Copyright (c) 2020 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_rabbit_hook_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-include("emqx_rabbit_hook.hrl").

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {{one_for_one, 10, 100}, child_spec(true)}}.


child_spec(UsePool) ->
    case UsePool of
        true ->
            {ok, Opts} = application:get_env(?APP, server),
%%            todo: set auto_reconnect and pool_size options
            [ecpool:pool_spec(?APP, ?APP, emqx_rabbit_hook_cli, Opts)];
        false ->
            []
    end.