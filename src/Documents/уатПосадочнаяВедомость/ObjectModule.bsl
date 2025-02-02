
#Область СлужебныйПрограммныйИнтерфейс

// Процедура рассчитывает в строке табличной части суммовое значение комиссии автостанции
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части , требующая пересчёта
// 
Процедура ПересчетКомиссии(СтрокаТабличнойЧасти) Экспорт
	
	СтрокаТабличнойЧасти.КомиссияАвтостанции = СтрокаТабличнойЧасти.Сумма * Автостанция.Комиссия / 100;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатПосадочнаяВедомость.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение_проф.ОтразитьВыручку(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатПосадочнаяВедомость.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
КонецПроцедуры
	
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("УправляемаяФорма") ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатПутевойЛист") Тогда
		Организация = ДанныеЗаполнения.Организация;
		ТС = ДанныеЗаполнения.ТранспортноеСредство;
		Сотрудник = ДанныеЗаполнения.Водитель1;
		
		Если Не ЗначениеЗаполнено(Дата) Тогда
			Дата = ДанныеЗаполнения.ДатаВыезда;
		КонецЕсли;
		
		// проверка уникальности номера
		Если ЗначениеЗаполнено(Номер) Тогда
			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	уатПосадочнаяВедомость.Ссылка
			|ИЗ
			|	Документ.уатПосадочнаяВедомость КАК уатПосадочнаяВедомость
			|ГДЕ
			|	уатПосадочнаяВедомость.Номер = &Номер
			|	И уатПосадочнаяВедомость.Ссылка <> &Ссылка
			|	И уатПосадочнаяВедомость.Дата МЕЖДУ &НачПериода И &КонПериода");
			Запрос.УстановитьПараметр("Номер", Номер);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.УстановитьПараметр("НачПериода", НачалоГода(Дата));
			Запрос.УстановитьПараметр("КонПериода", КонецГода(Дата));
			Если НЕ Запрос.Выполнить().Пустой() Тогда
				Номер = "";
			КонецЕсли;
		КонецЕсли;
		
		// добавим основной ТС
		НоваяСтрока 				= Билеты.Добавить();
		НоваяСтрока.ПутевойЛист 	= ДанныеЗаполнения.Ссылка;
		//
		Для Каждого ТекСтрока Из ДанныеЗаполнения.Задание Цикл
			Если ЗначениеЗаполнено(ТекСтрока.Маршрут) Тогда
				НоваяСтрока.Маршрут = ТекСтрока.Маршрут;
				Прервать
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = уатОбщегоНазначенияТиповые.уатПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
КонецПроцедуры // ПередЗаписью

#КонецОбласти
