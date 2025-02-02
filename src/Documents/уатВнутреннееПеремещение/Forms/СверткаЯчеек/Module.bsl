
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("Период", Период);
	Параметры.Свойство("Склад", Склад);
	Параметры.Свойство("Номенклатура", Номенклатура);
	ЗаполнитьОстатки();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьСвертку(Команда)
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ЯчейкаПолучатель", ЯчейкаПолучатель);
	СтруктураРезультата.Вставить("Номенклатура", Номенклатура);
	
	мсвОстаткиВЯчейках = Новый Массив;
	Для Каждого ТекСтрока Из ОстаткиВЯчейках Цикл
		Если НЕ ТекСтрока.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураСтроки = Новый Структура("Ячейка, Количество",
			ТекСтрока.Ячейка, ТекСтрока.Количество);
		мсвОстаткиВЯчейках.Добавить(СтруктураСтроки);
	КонецЦикла;
	СтруктураРезультата.Вставить("ОстаткиВЯчейках", мсвОстаткиВЯчейках);
	
	Закрыть(СтруктураРезультата);
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	Для Каждого ТекСтрока Из ОстаткиВЯчейках Цикл
		ТекСтрока.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	Для Каждого ТекСтрока Из ОстаткиВЯчейках Цикл
		ТекСтрока.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	ЗаполнитьОстатки();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОстатки()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	уатТоварыВЯчейкахОстатки.Ячейка КАК Ячейка,
	|	уатТоварыВЯчейкахОстатки.КоличествоОстаток КАК Количество,
	|	ЛОЖЬ КАК Пометка
	|ИЗ
	|	РегистрНакопления.уатТоварыВЯчейках.Остатки(
	|			&Период,
	|			Склад = &Склад
	|				И Номенклатура = &Номенклатура) КАК уатТоварыВЯчейкахОстатки");
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	тблОстаткиНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(тблОстаткиНоменклатуры, "ОстаткиВЯчейках");
	
КонецПроцедуры

#КонецОбласти
