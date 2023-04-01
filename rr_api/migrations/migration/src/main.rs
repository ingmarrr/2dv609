use chrono;

fn main() {
    let curr_date = chrono::Utc::now();
    let date_str = curr_date.format("%Y%m%d%H%M%S").to_string();
    let mut file_name = String::new();
    println!("Enter the name of the file: ");
    std::io::stdin().read_line(&mut file_name).unwrap();
    file_name.pop();
    file_name.insert_str(0, &date_str);
    file_name.push_str(".sql");
    let mut file = std::fs::File::create("rr_api/migrations/" + file_name).unwrap();
}
