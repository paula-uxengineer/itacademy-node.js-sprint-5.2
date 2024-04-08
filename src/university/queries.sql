--1  Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre FROM persona WHERE tipo = 'alumno' ORDER BY apellido1 ASC, apellido2 ASC, nombre ASC;

--2 Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = 'alumno' AND telefono IS NULL;

--3 Llista totes les columnes de la taula producto.
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

--4 Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%K';

--5 Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT nombre FROM asignatura WHERE curso = 3 AND cuatrimestre = 1 AND id_grado = 7;

--6 Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS nombre_departamento FROM persona AS p INNER JOIN profesor AS pr ON p.id = pr.id_profesor INNER JOIN departamento AS d ON pr.id_departamento = d.id WHERE p.tipo = 'profesor' ORDER BY p.apellido1, p.apellido2, p.nombre;

--7 Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT a.nombre AS nombre_asignatura, ce.anyo_inicio, ce.anyo_fin FROM persona AS p JOIN alumno_se_matricula_asignatura AS asma ON p.id = asma.id_alumno JOIN asignatura AS a ON asma.id_asignatura = a.id JOIN curso_escolar AS ce ON asma.id_curso_escolar = ce.id WHERE p.nif = '26902806M';

--8 Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT d.nombre FROM departamento AS d JOIN profesor AS p ON d.id = p.id_departamento JOIN asignatura AS a ON p.id_profesor = a.id_profesor JOIN grado AS g ON a.id_grado = g.id WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

--9 Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2 FROM persona AS p JOIN alumno_se_matricula_asignatura AS a ON p.id = a.id_alumno JOIN curso_escolar AS c ON a.id_curso_escolar = c.id WHERE CONCAT(c.anyo_inicio, '/', c.anyo_fin) = '2018/2019';


--------- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN. ---------

--1 Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT departamento.nombre AS nom_departament, persona.apellido1, persona.apellido2, persona.nombre FROM persona LEFT JOIN profesor ON persona.id = profesor.id_profesor LEFT JOIN departamento ON profesor.id_departamento = departamento.id WHERE persona.tipo = 'profesor' ORDER BY nom_departament ASC, persona.apellido1 ASC, persona.apellido2 ASC, persona.nombre ASC;

--2 Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT persona.apellido1, persona.apellido2, persona.nombre FROM persona LEFT JOIN profesor ON persona.id = profesor.id_profesor WHERE persona.tipo = 'profesor' AND profesor.id_departamento IS NULL ORDER BY persona.apellido1 ASC, persona.apellido2 ASC, persona.nombre ASC;

--3 Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT departamento.nombre FROM departamento LEFT JOIN profesor ON departamento.id = profesor.id_departamento WHERE profesor.id_departamento IS NULL;

--4 Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT persona.apellido1, persona.apellido2, persona.nombre FROM persona LEFT JOIN profesor ON persona.id = profesor.id_profesor LEFT JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor WHERE persona.tipo = 'profesor' AND asignatura.id_profesor IS NULL ORDER BY persona.apellido1 ASC, persona.apellido2 ASC, persona.nombre ASC;

--5 Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT nombre FROM asignatura WHERE id_profesor IS NULL;

--6 Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT d.nombre FROM departamento d LEFT JOIN profesor p ON d.id = p.id_departamento LEFT JOIN asignatura a ON p.id_profesor = a.id_profesor LEFT JOIN alumno_se_matricula_asignatura m ON a.id = m.id_asignatura WHERE m.id_alumno IS NULL;


--------- Consultes resum: ---------

--1 Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(*) AS total_alumnos FROM alumno;

--2 Calcula quants alumnes van néixer en 1999.
SELECT COUNT(*) AS total_alumnos_1999 FROM alumno WHERE YEAR(data_naixement) = 1999;

--3 Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT d.nom_departament, COUNT(p.id_professor) AS num_professors FROM departament d INNER JOIN professor p ON d.id_departament = p.id_departament GROUP BY d.nom_departament ORDER BY num_professors DESC;

--4 Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT d.nom_departament, COUNT(p.id_professor) AS num_professors FROM departament d LEFT JOIN professor p ON d.id_departament = p.id_departament GROUP BY d.nom_departament ORDER BY num_professors DESC;

--5 Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nom_grau, COUNT(a.id_assignatura) AS num_assignatures FROM grau g LEFT JOIN assignatura a ON g.id_grau = a.id_grau GROUP BY g.nom_grau ORDER BY num_assignatures DESC;
