This explains how the project works

We start in `DiscordBotAppProtocol.swift`, it defines setting up a bot (user sets up bot gateway).

`Entrypoint.swift` defines a main func that inits the conforming object and executes the `run()` func

the `run()` func reads the scene data (declared events and commands) and adds them to the botinstance object so dispatched events are ran.
botinstance
