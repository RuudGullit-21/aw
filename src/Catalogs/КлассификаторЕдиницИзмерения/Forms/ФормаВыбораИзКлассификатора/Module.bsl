
#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоискСуществующейЕдиницы(Знач ПараметрыФормы)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КлассификаторЕдиницИзмерения.Ссылка
	|ИЗ
	|	Справочник.КлассификаторЕдиницИзмерения КАК КлассификаторЕдиницИзмерения
	|ГДЕ
	|	КлассификаторЕдиницИзмерения.Код = &Код";
	
	Запрос.УстановитьПараметр("Код", ПараметрыФормы.ЗначенияЗаполнения.Код);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьВыбор(ТекущаяОбласть)
	
	КодЧисловой         = ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьКодЧисловойЛево,
		ТекущаяОбласть.Низ, ОбластьКодЧисловойПраво).Текст;
	НаименованиеКраткое = ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеКраткоеЛево,
		ТекущаяОбласть.Низ, ОбластьНаименованиеКраткоеПраво).Текст;
	НаименованиеПолное  = ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеПолноеЛево,
		ТекущаяОбласть.Низ, ОбластьНаименованиеПолноеПраво).Текст;
	
	ЗначенияЗаполнения = Новый Структура("Код, Наименование, НаименованиеПолное",
		КодЧисловой, СтрПолучитьСтроку(НаименованиеКраткое, 1), СтрПолучитьСтроку(НаименованиеПолное, 1));
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ЕдИзм = ПоискСуществующейЕдиницы(ПараметрыФормы);
	
	Если ЕдИзм <> Неопределено Тогда
		ПараметрыФормы.Вставить("Ключ", ЕдИзм);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.ФормаЭлемента",
			ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Область = Элементы.ТабДокумент.ТекущаяОбласть;
	ВыполнитьВыбор(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокументВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Область = Элементы.ТабДокумент.ТекущаяОбласть;
	ВыполнитьВыбор(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура ИскатьСтрокуВТаблице(Команда)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ТекущийЭлемент = Элементы.СтрокаПоиска;
		ТекстНСТР = НСтр("en='Not specified search line';ru='Не задана строка поиска'");
		ПоказатьПредупреждение(Неопределено, ТекстНСТР);
		Возврат;
	КонецЕсли;
	
	НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска, Элементы.ТабДокумент.ТекущаяОбласть,
		,,,, Истина);
	Если НайденнаяОбласть = Неопределено Тогда
		НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска, , , , , , Истина);
		Если НайденнаяОбласть = Неопределено Тогда
			ТекстНСТР = НСтр("en='Line is not found';ru='Строка не найдена'");
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР);
			ТекущийЭлемент = Элементы.СтрокаПоиска;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийЭлемент = Элементы.ТабДокумент;
	ТекущийЭлемент.ТекущаяОбласть = НайденнаяОбласть;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Параметры.Свойство("СтрокаПоиска") Тогда
		СтрокаПоиска = ЭтаФорма.Параметры.СтрокаПоиска;
	КонецЕсли;
	
	Если Метаданные.ОбщиеМодули.Найти("уатЛокализация") <> Неопределено Тогда
		МодульЛокализация = ОбщегоНазначения.ОбщийМодуль("уатЛокализация");
		Макет = МодульЛокализация.ПолучитьМакет_КлассификаторЕдиницИзмерения();
	Иначе
		Макет = Справочники.КлассификаторЕдиницИзмерения.ПолучитьМакет("КлассификаторЕдиницИзмерения");
	КонецЕсли;
	ТабДокумент.Вывести(Макет);
	ТабДокумент.ФиксацияСверху = 1;
	
	ОбластьКодЧисловойЛево          = Макет.Области.КодЧисловой.Лево;
	ОбластьКодЧисловойПраво         = Макет.Области.КодЧисловой.Право;
	ОбластьНаименованиеКраткоеЛево  = Макет.Области.НаименованиеКраткое.Лево;
	ОбластьНаименованиеКраткоеПраво = Макет.Области.НаименованиеКраткое.Право;
	ОбластьНаименованиеПолноеЛево   = Макет.Области.НаименованиеПолное.Лево;
	ОбластьНаименованиеПолноеПраво  = Макет.Области.НаименованиеПолное.Право;
	
	Если НЕ ПустаяСтрока(СтрокаПоиска) Тогда
		НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска,, ТабДокумент.Области.КодЧисловой,,,, Истина);
		Если НайденнаяОбласть = Неопределено Тогда
			ТекущийЭлемент = Элементы.СтрокаПоиска;
		Иначе
			ТекущийЭлемент = Элементы.ТабДокумент;
			ТекущийЭлемент.ТекущаяОбласть = НайденнаяОбласть;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти