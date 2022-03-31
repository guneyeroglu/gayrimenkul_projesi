var myServer = "GUNEYPC"; //Kendi DB server isminizi yazın.

const config = {
  user: "sa", //Server'a girerken kullandığınız user bilgisi.
  password: "1234", //Server'a girerken kullandığınız şifre.
  server: myServer,
  database: "Insaat", //Verilen .sql uzantılı dosyayı kurarken tercih edilen DB ismi. Değişiklik yapılmadığında default olarak "Inşaat" ismi ile kuruluyor.
  options: {
    port: 1433,
    encrypt: false,
  },
  pool: {
    max: 20,
    min: 5,
    idleTimeoutMillis: 150000,
  },
};

module.exports = {
  Config: config,
};
