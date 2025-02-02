#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция получает таблицу ссылок на банки по Коду или корреспондетскому счету.
//
// Параметры:
//  Поле	 - Строка	 - Имя поля (Код или КоррСчет)
//  Значение - Строка	 - Значение Код или Корреспондентского счета
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Найденые банки
//
Функция ПолучитьТаблицуБанковПоРеквизитам(Поле, Значение) Экспорт
	
	ТаблицаБанков = Новый ТаблицаЗначений;
	Колонки = ТаблицаБанков.Колонки;
	Колонки.Добавить("Ссылка");
	Колонки.Добавить("Код");
	Колонки.Добавить("КоррСчет");
	
	ЭтоКод = Ложь;
	ЭтоКоррСчет = Ложь;
	Если Найти(Поле, "Код") <> 0 Тогда
		ЭтоКод = Истина;
	ИначеЕсли Найти(Поле, "КоррСчет") <> 0 Тогда
		ЭтоКоррСчет = Истина;
	КонецЕсли;
	
	Если ЭтоКод И СтрДлина(Значение) = 9
	 ИЛИ ЭтоКоррСчет И СтрДлина(Значение) = 20
	Тогда
		
		Если ЭтоКод Тогда
			СтруктураОтбора = Новый Структура("Код", Значение);
			
		ИначеЕсли ЭтоКоррСчет Тогда
			СтруктураОтбора = Новый Структура("КоррСчет", Значение);
			
		КонецЕсли;
		
		Выборка = Справочники.Банки.Выбрать( , , СтруктураОтбора, "Код Возр");
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ТаблицаБанков.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
		
		//Если ТаблицаБанков.Количество() = 0 Тогда
		//	ДобавитьБанкиИзКлассификатора(
		//		?(ЭтоКод, Значение, ""), // Код
		//		?(ЭтоКоррСчет, Значение, ""), // КоррСчет
		//		ТаблицаБанков
		//	);
		//КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаБанков;
	
КонецФункции

// Возвращает ссылку на Банк
//
// Параметры:
//  БИК			 - Строка	 - Идентификатор банка
//  ЭтоРегион	 - Булево	 - Признак региона-группы банков
// 
// Возвращаемое значение:
//  Банк - 
//
Функция СсылкаНаБанк(БИК, ЭтоРегион = Ложь) Экспорт
	
	Если ПустаяСтрока(БИК) Тогда
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Банки.Ссылка
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Код = &БИК
	|	И Банки.ЭтоГруппа = &ЭтоГруппа";
	
	Запрос.УстановитьПараметр("БИК",       БИК);
	Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоРегион);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

// Выполняет обновление данных банков из классификатора
//
// Параметры:
//  СтруктураПараметров	 - Структура - Дополнительные параметры
//  АдресХранилища		 - УИН, Строка	 - Адрес хранилища данных классификатора
//
Процедура ОбновитьБанкиИзКлассификатора(СтруктураПараметров, АдресХранилища) Экспорт
	
	МассивБанков        = Новый Массив();
	ДанныеДляЗаполнения = Новый Структура();
	
	УспешноОбновлены = ВыполнитьОбновлениеБанковИзКлассификатора();
	
	ДанныеДляЗаполнения.Вставить("УспешноОбновлены",   УспешноОбновлены);
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

// Функция - Страна по SWIFT
//
// Параметры:
//  СВИФТБИК - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция СтранаПоSWIFT(СВИФТБИК) Экспорт
	
	//КодСтраны = БанковскиеПравила.КодСтраныSWIFT(СВИФТБИК);
	КодСтраны = Сред(СВИФТБИК,5,2);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодАльфа2", КодСтраны);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтраныМира.Ссылка
	|ИЗ
	|	Справочник.СтраныМира КАК СтраныМира
	|ГДЕ
	|	СтраныМира.КодАльфа2 = &КодАльфа2";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		ВсеСтраны = РаботаСАдресами.ТаблицаКлассификатора();
		ВсеСтраны.Индексы.Добавить("КодАльфа2");
		ОписаниеСтраны = ВсеСтраны.Найти(КодСтраны);
		Если ОписаниеСтраны <> Неопределено Тогда
			Страна = Справочники.СтраныМира.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(Страна, ОписаниеСтраны);
			Страна.Записать();
			
			Возврат Страна.Ссылка;
		Иначе
			Возврат Справочники.СтраныМира.Россия;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ВыполнитьОбновлениеБанковИзКлассификатора()
	
	ОбластьОбработана = Истина;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КлассификаторБанков.Код КАК Код,
	|	КлассификаторБанков.КоррСчет КАК КоррСчет,
	|	КлассификаторБанков.Наименование КАК Наименование,
	|	КлассификаторБанков.Город КАК Город,
	|	КлассификаторБанков.Адрес КАК Адрес,
	|	КлассификаторБанков.Телефоны КАК Телефоны,
	|	КлассификаторБанков.ЭтоГруппа КАК ЭтоГруппа,
	|	КлассификаторБанков.Родитель.Код КАК РодительКод,
	|	КлассификаторБанков.Родитель.Наименование КАК РодительНаименование,
	|	КлассификаторБанков.ДеятельностьПрекращена КАК ДеятельностьПрекращена,
	|	КлассификаторБанков.СВИФТБИК КАК СВИФТБИК,
	|	ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия) КАК Страна
	|ПОМЕСТИТЬ ВТ_ИзмененныеБанки
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Код,
	|	КоррСчет,
	|	Наименование,
	|	ЭтоГруппа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВложенныйЗапросБанки.Банк КАК Банк,
	|	ВложенныйЗапросБанки.Код КАК Код,
	|	ВложенныйЗапросБанки.КоррСчет КАК КоррСчет,
	|	ВложенныйЗапросБанки.Наименование КАК Наименование,
	|	ВложенныйЗапросБанки.Город КАК Город,
	|	ВложенныйЗапросБанки.Адрес КАК Адрес,
	|	ВложенныйЗапросБанки.Телефоны КАК Телефоны,
	|	ВложенныйЗапросБанки.ЭтоГруппа КАК ЭтоГруппа,
	|	ВложенныйЗапросБанки.РодительКод КАК РодительКод,
	|	ВложенныйЗапросБанки.РодительНаименование КАК РодительНаименование,
	|	ВложенныйЗапросБанки.ДеятельностьПрекращена КАК ДеятельностьПрекращена,
	|	ВложенныйЗапросБанки.СВИФТБИК КАК СВИФТБИК,
	|	ВложенныйЗапросБанки.Страна
	|ПОМЕСТИТЬ ВТ_ИзмененныеЭлементы
	|ИЗ
	|	(ВЫБРАТЬ
	|		Банки.Ссылка КАК Банк,
	|		ВТ_ИзмененныеБанки.Код КАК Код,
	|		ВТ_ИзмененныеБанки.КоррСчет КАК КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование КАК Наименование,
	|		ВТ_ИзмененныеБанки.Город КАК Город,
	|		ВТ_ИзмененныеБанки.Адрес КАК Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны КАК Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа КАК ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод КАК РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование КАК РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена КАК ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК КАК СВИФТБИК,
	|		ВТ_ИзмененныеБанки.Страна КАК Страна
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Наименование <> ВТ_ИзмененныеБанки.Наименование
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК,
	|		ВТ_ИзмененныеБанки.Страна
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Город <> ВТ_ИзмененныеБанки.Город
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК,
	|		ВТ_ИзмененныеБанки.Страна
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Адрес <> ВТ_ИзмененныеБанки.Адрес
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК,
	|		ВТ_ИзмененныеБанки.Страна
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Телефоны <> ВТ_ИзмененныеБанки.Телефоны
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК,
	|		ВТ_ИзмененныеБанки.Страна
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Родитель.Код <> ВТ_ИзмененныеБанки.РодительКод
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа) КАК ВложенныйЗапросБанки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_ИзмененныеЭлементы.Банк КАК Банк,
	|	ВТ_ИзмененныеЭлементы.Код КАК Код,
	|	ВТ_ИзмененныеЭлементы.КоррСчет КАК КоррСчет,
	|	ВТ_ИзмененныеЭлементы.Наименование КАК Наименование,
	|	ВТ_ИзмененныеЭлементы.Город КАК Город,
	|	ВТ_ИзмененныеЭлементы.Адрес КАК Адрес,
	|	ВТ_ИзмененныеЭлементы.Телефоны КАК Телефоны,
	|	ВТ_ИзмененныеЭлементы.ЭтоГруппа КАК ЭтоГруппа,
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Родитель,
	|	ВТ_ИзмененныеЭлементы.РодительКод КАК РодительКод,
	|	ВТ_ИзмененныеЭлементы.РодительНаименование КАК РодительНаименование,
	|	ВТ_ИзмененныеЭлементы.ДеятельностьПрекращена КАК ДеятельностьПрекращена,
	|	ВТ_ИзмененныеЭлементы.СВИФТБИК КАК СВИФТБИК,
	|	ВТ_ИзмененныеЭлементы.Страна
	|ИЗ
	|	ВТ_ИзмененныеЭлементы КАК ВТ_ИзмененныеЭлементы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_ИзмененныеЭлементы.РодительКод = Банки.Код
	|			И (Банки.ЭтоГруппа)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Банки.Ссылка,
	|	ВТ_ИзмененныеБанки.Код,
	|	NULL,
	|	ВТ_ИзмененныеБанки.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ЭтоГруппа,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|	NULL,
	|	NULL
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|		ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|			И Банки.Наименование <> ВТ_ИзмененныеБанки.Наименование
	|			И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|ГДЕ
	|	ВТ_ИзмененныеБанки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтоГруппа УБЫВ";
	
	ВыборкаБанков = Запрос.Выполнить().Выбрать();
	
	ИсключаяСвойстваДляЭлемента = "ЭтоГруппа";
	ИсключаяСвойстваДляГруппы   = "Адрес, Город, КоррСчет, Телефоны, Родитель, СВИФТБИК, Страна, ЭтоГруппа";
	ИмяСобытияВЖурналеРегистрации = НСтр("en='Banks classification';ru='Классификатор банков'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	Пока ВыборкаБанков.Следующий() Цикл
		
		Банк = ВыборкаБанков.Банк.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(Банк, ВыборкаБанков,,
			?(ВыборкаБанков.ЭтоГруппа, ИсключаяСвойстваДляГруппы, ИсключаяСвойстваДляЭлемента));
		
		Если НЕ ВыборкаБанков.ЭтоГруппа И НЕ ЗначениеЗаполнено(ВыборкаБанков.Родитель) И НЕ ПустаяСтрока(ВыборкаБанков.РодительКод) Тогда
			Родитель = Справочники.Банки.СсылкаНаБанк(ВыборкаБанков.РодительКод, Истина);
			Если НЕ ЗначениеЗаполнено(Родитель) Тогда
				Родитель = Справочники.Банки.СоздатьГруппу();
				Родитель.Код          = ВыборкаБанков.РодительКод;
				Родитель.Наименование = ВыборкаБанков.РодительНаименование;
				
				Попытка
					Родитель.Записать();
				Исключение
					
					ТекстНСТР      = НСтр("en='Failed to record a group (region) %1.';ru='Не удалось записать группу (регион) %1.'") + Символы.ПС + "%2";
					ТекстСообщения = СтрШаблон(
						ТекстНСТР,
						ВыборкаБанков.РодительНаименование,
						ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						
					ЗаписьЖурналаРегистрации(
						ИмяСобытияВЖурналеРегистрации, 
						УровеньЖурналаРегистрации.Ошибка,
						Метаданные.Справочники.Банки,
						ВыборкаБанков.Банк, 
						ТекстСообщения);
					
					ОбластьОбработана = Ложь;
					Прервать;
				КонецПопытки
			КонецЕсли;
			
			Банк.Родитель = Родитель.Ссылка;
		КонецЕсли;
		
		Попытка
			Банк.Записать();
		Исключение
			ТекстНСТР      = НСтр("en='Unable to write element.';ru='Не удалось записать элемент.'") + "%1";
			ТекстСообщения = СтрШаблон(
				ТекстНСТР,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ЗаписьЖурналаРегистрации(
				ИмяСобытияВЖурналеРегистрации,
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Банки,
				ВыборкаБанков.Банк,
				ТекстСообщения);
			
			ОбластьОбработана = Ложь;
		КонецПопытки;
	КонецЦикла;
	
	Если НЕ ОбластьОбработана Тогда
		Возврат ОбластьОбработана;
	КонецЕсли;
	
	// Найдем банки которые потеряли связь с классификатором
	// и установим им соотвествующий признак
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Банки.Ссылка КАК Банк
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО Банки.Код = КлассификаторБанков.Код
	|			И (Банки.ЭтоГруппа
	|				ИЛИ Банки.КоррСчет = КлассификаторБанков.КоррСчет)
	|ГДЕ
	|	КлассификаторБанков.Ссылка ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Банки.Ссылка
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО Банки.Код = КлассификаторБанков.Код
	|			И (Банки.ЭтоГруппа
	|				ИЛИ Банки.КоррСчет = КлассификаторБанков.КоррСчет)
	|ГДЕ
	|	КлассификаторБанков.ДеятельностьПрекращена";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Банк = Выборка.Банк.ПолучитьОбъект();
		
		Попытка
			Банк.Записать();
		Исключение
			ОбластьОбработана = Ложь;
			
			ТекстНСТР      = НСтр("en='Unable to write element.';ru='Не удалось записать элемент.'") + Символы.ПС + "%1";
			ТекстСообщения = СтрШаблон(ТекстНСТР,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ИмяСобытияВЖурналеРегистрации, 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Банки,
				Выборка.Банк, 
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Возврат ОбластьОбработана;
	
КонецФункции

#КонецОбласти

#КонецЕсли