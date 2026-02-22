@regresion
Feature: Automatizar el backend de Pet Store

  Background:
    * url apiPetStore
    * def jsonCrearMascota = read('classpath:examples/jsonData/crearMascota.json')
    * def jsonActualizarMascota = read('classpath:examples/jsonData/actualizarMascota.json')

  @TEST-1 @happypath @crearMascota
  Scenario: Verificar la creacion de una nueva mascota en Pet Store - OK
    Given path 'pet'
    And request jsonCrearMascota
    When method post
    Then status 200
    And match response.id == 84
    And match response.name == 'Lucas'
    And match response.status == 'available'
    * def idPet = response.id
    And print idPet

  @TEST-2 @happypath
  Scenario: Verificar la actualizacion de mascota en Pet Store - OK
    Given path 'pet'
    And request jsonCrearMascota.id = 84
    And request jsonCrearMascota.name = 'Boby'
    And request jsonCrearMascota
    When method put
    Then status 200
    And print response

  @TEST-3 @happypath
  Scenario Outline: Verificar la Busqueda de Mascotas de Pet Store por estado(available, sold, pending)- OK
    Given path 'pet/findByStatus'
    And param status = '<estado>'
    When method get
    Then status 200
    And print response

    Examples:
    |estado   |
    |available|
    |sold     |
    |pending  |

  @TEST-4 @happypath
  Scenario Outline: Verificar la Busqueda de Mascotas de Pet Store por id - OK
    Given path 'pet/' + <idPet>
    When method get
    Then status 200
    And print response

    Examples:
    |idPet|
    |4    |
    |84    |
    |7    |

  @TEST-5 @happypath
  Scenario Outline: Verificar la Eliminacion de Mascotas de Pet Store por id - OK
    Given path 'pet/' + <idPet>
    When method delete
    Then status 200
    And print response

    Examples:
    |idPet|
    |4   |
    |84   |
    |7  |


  @TEST-6 @happypath
  Scenario: Verificar la eliminacion de Mascotas de Pet Store por id - OK
    Given path 'pet/5'
    When method delete
    Then status 200
    And print response

  @TEST-7 @happypath
  Scenario: Subir una imagen para una mascota existente
    Given path 'pet', 2, 'uploadImage'
    And multipart file file = { read: 'classpath:examples/imagenes/perrito.jpg', filename: 'perrito.jpg', contentType: 'image/jpeg' }
    And multipart field additionalMetadata = 'Foto de perfil actualizada'
    When method post
    Then status 200


  # mvn clean test -Dtest=UsersRunner -Dkarate.options="--tags @TEST-2" -Dkarate.env=dev
  # mvn clean test -Dtest=UsersRunner -Dkarate.options="--tags @TEST-2"

  @TEST-8 @happypath
  Scenario: Verificar la Busqueda de Mascotas de Pet Store por id - OK
    * def idMascota = call read('classpath:examples/users/users.feature@crearMascota')
    Given path 'pet/' + idMascota.idPet
    When method get
    Then status 200
    And print response
