#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область СлужебныйПрограммныйИнтерфейс

// Задает настройки размещения вариантов отчетов в панели отчетов.
// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       См. ""Реквизиты для изменения"" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Грузы к поступлению на склад по Заказам на ТС");
	НастройкиВарианта.Описание = НСтр("en='Report is intended to show cargoes for receiving to warehouse by orders for trucking.';ru='Отчет предназначен для отображения грузов, ожидаемых к поступлению на склад по заказам на ТС.'");
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Грузы к поступлению на склад по Маршрутным листам");
	НастройкиВарианта.Описание = НСтр("en='Report is intended to show cargos for receiving to warehouse by routing lists.';ru='Отчет предназначен для отображения грузов, ожидаемых к поступлению на склад по маршрутным листам.'");
	
КонецПроцедуры

// Возвращает вес номенклатуры
//
// Параметры:
//  Номенклатура	 - 	 - Неопределено, Грузовое место, спр. Номенклатура
//  	Единица измерения
//  ЕдиницаИзмерения - 	 - 
//  Количество		 - 	 - 
//  Заказ			 - 	 - 
// 
// Возвращаемое значение:
//  Вес, кг - 
//
Функция ВесНоменклатуры(Номенклатура, ЕдиницаИзмерения, Количество, Заказ) Экспорт
	
	Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.уатГрузовыеМеста_уэ") Тогда
		СтрокаГруза = Заказ.ГрузовойСостав.Найти(Номенклатура, "ГрузовоеМесто");
		Если СтрокаГруза = Неопределено Тогда
			МестВсего = ?(Номенклатура.КоличествоМест = 0, 1, Номенклатура.КоличествоМест);
			Рез = Номенклатура.ВесБрутто * (Количество / МестВсего);
		Иначе
			МестВсего = ?(СтрокаГруза.КоличествоМест = 0, 1, СтрокаГруза.КоличествоМест);
			Рез = СтрокаГруза.ВесБрутто * (Количество / МестВсего);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		СтрокиТовара = Заказ.Товары.НайтиСтроки(Новый Структура("Номенклатура, ЕдиницаИзмерения", Номенклатура, ЕдиницаИзмерения));
		Если СтрокиТовара.Количество() Тогда 
			МестВсего = ?(СтрокиТовара[0].Количество = 0, 1, СтрокиТовара[0].Количество);
			Рез = СтрокиТовара[0].ВесБрутто * (Количество / МестВсего);
		Иначе
			ВесОбъем = уатОбщегоНазначения.ПолучитьВесОбъемНоменклатуры(Номенклатура, ЕдиницаИзмерения, Количество);
			Рез = ВесОбъем.Вес;
		КонецЕсли;
		
	ИначеЕсли Заказ.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам Тогда 
		Рез = Заказ.ВесБрутто;
		
	Иначе
		Рез = 0;
	КонецЕсли;
	
	Возврат Рез;
	
КонецФункции

// Возвращает объем номенклатуры
//
// Параметры:
//  Номенклатура	 - 	 - Неопределено, Грузовое место, спр. Номенклатура
//  	Единица измерения
//  ЕдиницаИзмерения - 	 - 
//  Количество		 - 	 - 
//  Заказ			 - 	 - 
// 
// Возвращаемое значение:
//  Объем, м3 - 
//
Функция ОбъемНоменклатуры(Номенклатура, ЕдиницаИзмерения, Количество, Заказ) Экспорт
	
	Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.уатГрузовыеМеста_уэ") Тогда
		СтрокаГруза = Заказ.ГрузовойСостав.Найти(Номенклатура, "ГрузовоеМесто");
		Если СтрокаГруза = Неопределено Тогда
			МестВсего = ?(Номенклатура.КоличествоМест = 0, 1, Номенклатура.КоличествоМест);
			Рез = Номенклатура.Объем * (Количество / МестВсего);
		Иначе
			МестВсего = ?(СтрокаГруза.КоличествоМест = 0, 1, СтрокаГруза.КоличествоМест);
			Рез = СтрокаГруза.Объем * (Количество / МестВсего);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		СтрокиТовара = Заказ.Товары.НайтиСтроки(Новый Структура("Номенклатура, ЕдиницаИзмерения", Номенклатура, ЕдиницаИзмерения));
		
		Если СтрокиТовара.Количество() Тогда 
			МестВсего = ?(СтрокиТовара[0].Количество = 0, 1, СтрокиТовара[0].Количество);
			Рез = СтрокиТовара[0].Объем * (Количество / МестВсего);
		Иначе
			ВесОбъем = уатОбщегоНазначения.ПолучитьВесОбъемНоменклатуры(Номенклатура, ЕдиницаИзмерения, Количество);
			Рез = ВесОбъем.Объем;
		КонецЕсли;
		
	ИначеЕсли Заказ.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам Тогда 
		Рез = Заказ.Объем;
		
	Иначе
		Рез = 0;
	КонецЕсли;
	
	Возврат Рез;
	
КонецФункции

// Возвращает количество мест номенклатуры
//
// Параметры:
//  Номенклатура	 - 	 - Неопределено, Грузовое место, спр. Номенклатура
//  	Единица измерения
//  ЕдиницаИзмерения - 	 - 
//  Количество		 - 	 - 
//  Заказ			 - 	 - 
// 
// Возвращаемое значение:
//  Количество - мест
//
Функция КоличествоМестНоменклатуры(Номенклатура, ЕдиницаИзмерения, Количество, Заказ) Экспорт
	
	Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.уатГрузовыеМеста_уэ") Тогда
		Рез = Количество;
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		СтрокиТовара = Заказ.Товары.НайтиСтроки(Новый Структура("Номенклатура, ЕдиницаИзмерения", Номенклатура, ЕдиницаИзмерения));
		Если СтрокиТовара.Количество() Тогда 
			МестВсего = ?(СтрокиТовара[0].Количество = 0, 1, СтрокиТовара[0].Количество);
			Рез = СтрокиТовара[0].КоличествоМест * (Количество / МестВсего);
		Иначе
			ВесОбъем = уатОбщегоНазначения.ПолучитьВесОбъемНоменклатуры(Номенклатура, ЕдиницаИзмерения, Количество);
			Рез = ВесОбъем.КоличествоМест;
		КонецЕсли;
		
	ИначеЕсли Заказ.ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоЗаказам Тогда 
		Рез = Заказ.КоличествоМест;
		
	Иначе
		Рез = 0;
	КонецЕсли;
	
	Возврат Рез;
	
КонецФункции

#КонецОбласти

	
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатОтчетОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли