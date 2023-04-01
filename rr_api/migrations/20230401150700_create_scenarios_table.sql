
create table if not exists scenarios {
    id bigint    generated by default as identity,
    name         varchar(255) not null default '',
    category     varchar(255) not null default '',
    description  text         not null default '',
    keywords     text[]       not null default '{}',
    instructions text         not null default '',
    created_at   timestamp    not null default now(),
    updated_at   timestamp    not null default now()
}