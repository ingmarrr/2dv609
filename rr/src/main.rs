use clap::{Args, Parser, Subcommand};

#[derive(Debug, Parser)]
#[clap(author, version, about)]
pub struct App {
    #[clap(subcommand)]
    pub ty: Ty,
}

#[derive(Debug, Subcommand)]
pub enum Ty {
    #[clap(name = "docker")]
    Docker(Docker),
    #[clap(name = "mig")]
    Migration(Migration),
}

#[derive(Debug, Args)]
pub struct Docker {
    #[clap(short, long)]
    name: String,

    #[clap(short, long)]
    build: bool,

    #[clap(short, long)]
    run: bool,

    #[clap(short, long)]
    stop: bool,

    #[clap(short, long)]
    remove: bool,
}

#[derive(Debug, Args)]
pub struct Migration {
    #[clap(short, long)]
    new: String,

    #[clap(short, long)]
    run: bool,
}

fn main() {
    let app = App::parse();

    match app.ty {
        Ty::Docker(docker) => {
            let name = docker.name;
            if docker.build {
                // run: docker build -t postgres-sbx -f postgres.Dockerfile .
                let mut child = std::process::Command::new("docker")
                    .arg("build")
                    .arg("-t")
                    .arg(&name)
                    .arg("-f")
                    .arg("postgres.Dockerfile")
                    .arg(".")
                    .spawn()
                    .expect("failed to execute process");
                let res = child.wait();
                if let Err(_) = res {
                    println!("Container already exists");
                };
            }

            if docker.run {
                // docker run -d --name postgres-sbx -p 5432:5432 postgres-sbx
                let mut child = std::process::Command::new("docker")
                    .arg("run")
                    .arg("-d")
                    .arg("--name")
                    .arg(&name)
                    .arg("-p")
                    .arg("5432:5432")
                    .arg(&name)
                    .spawn()
                    .expect("failed to execute process");

                let res = child.wait();
                if let Err(_) = res {
                    println!("Container is already being used.");
                    return;
                };

                // docker start postgres-sbx
                std::process::Command::new("docker")
                    .arg("start")
                    .arg(&name)
                    .spawn()
                    .expect("failed to execute process");
            }
        }

        Ty::Migration(migration) => {
            if migration.run {
                // sqlx migrate run
                std::process::Command::new("sqlx")
                    .arg("migrate")
                    .arg("run")
                    .spawn()
                    .expect("failed to execute process");
            }

            if migration.new != "" {
                let curr_date = chrono::Utc::now();
                let date_str = curr_date.format("%Y%m%d%H%M%S").to_string();
                let file_name = date_str + "_" + &migration.new + ".sql";
                let _ = std::fs::File::create(&file_name).unwrap();
            }
        }
    }
}
